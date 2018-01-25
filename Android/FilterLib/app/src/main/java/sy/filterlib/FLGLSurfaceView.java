package sy.filterlib;

import android.app.Activity;
import android.content.Context;
import android.graphics.ImageFormat;
import android.graphics.SurfaceTexture;
import android.hardware.Camera;
import android.opengl.GLES11Ext;
import android.opengl.GLES20;
import android.opengl.GLSurfaceView;
import android.util.AttributeSet;
import android.util.Log;
import android.view.SurfaceHolder;

import java.nio.ByteBuffer;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLContext;
import javax.microedition.khronos.opengles.GL10;


/**
 * 相机
 * Created by SHI.yang on 17/09/13.
 */

public class FLGLSurfaceView extends GLSurfaceView implements GLSurfaceView.Renderer, SurfaceTexture.OnFrameAvailableListener {

    private static final String TAG = FLGLSurfaceView.class.getSimpleName();

    private static String SCENE_NAME = "sceneMain";

    private SurfaceTexture mSurfaceTexture;

    int mTextureID = -1;

    private boolean mHasSurface;

    private EGLContext mSelfEGLContext;

    private FLJNI mFLJNI;

    private int mOutTexId;

    public FLGLSurfaceView(Context context, AttributeSet attrs) {
        super(context, attrs);
        setEGLContextClientVersion(2);

//        setEGLContextFactory(new EGLContextFactory() {
//
//            @Override
//            public EGLContext createContext(EGL10 egl, EGLDisplay display, EGLConfig eglConfig) {
//                int eglContextClientVersion;
//                if (Build.VERSION.SDK_INT > Build.VERSION_CODES.JELLY_BEAN_MR2) {
//                    eglContextClientVersion = EGL_CONTEXT_CLIENT_VERSION;
//                } else {
//                    eglContextClientVersion = 0x3098;
//                }
//                int[] attrib_list = {eglContextClientVersion, 2, EGL10.EGL_NONE};
//
//                mSelfEGLContext = egl.eglCreateContext(display, eglConfig, EGL10.EGL_NO_CONTEXT,
//                        attrib_list);
//                return mSelfEGLContext;
//            }
//
//            @Override
//            public void destroyContext(EGL10 egl, EGLDisplay display, javax.microedition.khronos.egl.EGLContext context) {
//                egl.eglDestroyContext(display, context);
//            }
//        });

        setRenderer(this);
        setRenderMode(RENDERMODE_WHEN_DIRTY);
    }


    @Override
    public void onSurfaceCreated(GL10 gl, EGLConfig config) {
        mTextureID = createOESTextureID(); //输入TexId
        mSurfaceTexture = new SurfaceTexture(mTextureID);
        mSurfaceTexture.setOnFrameAvailableListener(this);
        GLES20.glClearColor(1.0f, 1.0f, 0.0f, 0.0f);
        GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT);
        mHasSurface = true;
        openCamera(true);

        if (mFLJNI == null) {
//            post(new Runnable() {
//                @Override
//                public void run() {
//                    mFLJNI = new FLJNI();
//                    mFLJNI.FLInit();
//                    mFLJNI.FLSetSize(mCameraWidth, mCameraHeight);
//                }
//            });
        }

    }

    private int createOESTextureID() {
        int[] texture = new int[1];
        GLES20.glGenTextures(1, texture, 0);
        GLES20.glBindTexture(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, texture[0]);
        GLES20.glTexParameterf(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, GL10.GL_TEXTURE_MIN_FILTER, GL10.GL_LINEAR);
        GLES20.glTexParameterf(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, GL10.GL_TEXTURE_MAG_FILTER, GL10.GL_LINEAR);
        GLES20.glTexParameteri(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, GL10.GL_TEXTURE_WRAP_S, GL10.GL_CLAMP_TO_EDGE);
        GLES20.glTexParameteri(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, GL10.GL_TEXTURE_WRAP_T, GL10.GL_CLAMP_TO_EDGE);
        return texture[0];
    }


    @Override
    public void surfaceDestroyed(final SurfaceHolder holder) {
        if (mSurfaceTexture != null) {
            mSurfaceTexture.release();
            mSurfaceTexture = null;
        }

        mHasSurface = false;

        closeCamera();
        super.surfaceDestroyed(holder);
    }


    @Override
    public void onSurfaceChanged(GL10 gl, int width, int height) {
        GLES20.glViewport(0, 0, width, height);
        Log.e("shiyang FL", "shiyang onSurfaceChanged w="+width+",h="+height);
    }

    private int mCameraWidth, mCameraHeight;


    private final Object mLock = new Object();

    long time;

    @Override
    public void onDrawFrame(GL10 gl) {
//        GLES20.glViewport(0,0,720,1280);
//        GLES20.glClearColor(1.0f, 1.0f, 1.0f, 1.0f);

        synchronized (mLock) {
            if (!mHasSurface || mHasPaused) {
                return;
            }
            if (mFLJNI == null) {
//                post(new Runnable() {
//                    @Override
//                    public void run() {
                        mFLJNI = new FLJNI();
                        mFLJNI.FLInit();
                        mFLJNI.FLSetSize(mCameraWidth, mCameraHeight);
//                    }
//                });
//
            }
//            if (mFLJNI == null) {
//                return;
//            }
            mSurfaceTexture.updateTexImage();// this means mTextureID's data has been updated

//            GLES20.glViewport(0,0,720,1280);
//            GLES20.glClearColor(1.0f, 1.0f, 1.0f, 1.0f);

            mFLJNI.FLDraw(mTextureID);
            mLock.notifyAll();
        }
    }

    private boolean mHasPaused = false;

    private boolean mCameraHasOpened;

    private FLCamera mFLCamera;

    private boolean isFront;

    private ByteBuffer mCameraDataBuffer;

    //开启相机
    public void openCamera(boolean isFront) {
        if (mCameraHasOpened) {
            return;
        }
        if (mFLCamera == null) {
            try {
                mFLCamera = new FLCamera((Activity) getContext());
                mFLCamera.setPreviewSize(1280, 720);
                this.isFront = isFront;
                mFLCamera.open(ImageFormat.NV21, isFront);

                mFLCamera.start(mSurfaceTexture);
                mFLCamera.registerCameraPreviewListener(new Camera.PreviewCallback() {

                    @Override
                    public void onPreviewFrame(final byte[] data, final Camera camera) {
                        synchronized (mLock) {
                            time = System.currentTimeMillis();
                            try {
                                Camera.Parameters param = camera.getParameters();
                                Camera.Size t_size = param.getPreviewSize();
                                int cameraWidth = t_size.width;
                                int cameraHeight = t_size.height;

                                mCameraWidth = cameraWidth;
                                mCameraHeight = cameraHeight;
                                int size = cameraWidth * cameraHeight * 3 / 2;

                                if (mCameraDataBuffer == null) {
                                    mCameraDataBuffer = ByteBuffer.allocateDirect(size);//分配空间
                                }
                                mCameraDataBuffer.rewind();
                                mCameraDataBuffer.put(data);
                                if (null != mFLJNI) {
                                    mFLJNI.FLSetImageData(mCameraDataBuffer, mCameraWidth, mCameraHeight, size, 1);
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }

                            FLGLSurfaceView.this.requestRender();
                            try {
                                mLock.wait();
                            } catch (InterruptedException e) {
                                e.printStackTrace();
                            }
                        }

                        camera.addCallbackBuffer(data);

                    }
                });
                mCameraHasOpened = true;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void closeCamera() {
        mCameraHasOpened = false;
        if (mFLCamera != null) {
            mFLCamera.unRegisterCameraPreviewListener();
            mFLCamera.release();
            mFLCamera = null;
        }
    }

    @Override
    public void onFrameAvailable(SurfaceTexture surfaceTexture) {

    }

    @Override
    public void onResume() {
        super.onResume();
        mHasPaused = false;
        if (mHasSurface) {
            openCamera(true);
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        mHasPaused = true;
        closeCamera();
    }

    public void release() {
        Log.d(TAG, "release");
        closeCamera();


    }


}


