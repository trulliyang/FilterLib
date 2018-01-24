package sy.filterlib;

import android.graphics.ImageFormat;
import android.graphics.SurfaceTexture;
import android.hardware.Camera;
import android.opengl.GLES20;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.TextureView;
import android.view.View;

import java.nio.ByteBuffer;
import java.util.List;

import javax.microedition.khronos.egl.EGLContext;

public class MainActivity extends AppCompatActivity {

    private boolean mCameraHasOpened = false;
    private boolean mCameraIsPreviewing = false;
    private Camera mCamera = null;
    private SurfaceTexture mCameraSurfaceTexture = null;
    int[] mTextures = null;
    private int mCameraDisplayOrientationDegree;
    TextureView mTextureView = null;
    private View mContextView = null;
    private EGLContext  mEGLContext = null;
    private ByteBuffer mCameraDataBuffer = null;

    // Used to load the 'native-lib' library on application startup.
    static {
        System.loadLibrary("native-lib");
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mContextView = View.inflate(this, R.layout.activity_main, null);
        init();
        setContentView(mContextView);
    }

    private void init() {
        initGLRenderSys();
        initTextureView();
//        initRenderFramework();
    }

    private void initGLRenderSys() {
        GLRenderSys.getInstance().init(getApplicationContext(), mEGLContext);
    }

    private void initTextureView() {
        mTextureView = mContextView.findViewById(R.id.textureView);
        mTextureView.setOpaque(false);
        mTextureView.setSurfaceTextureListener(mSurfaceTextureListener);
        mTextureView.setVisibility(View.VISIBLE);
    }

    private void initRenderFramework() {
        nativeInitRenderFramework();
    }

    @Override
    protected void onResume() {
        super.onResume();
        //重新开启相机
        openCamera(false);
//
        //引擎重新启动(跑渲染和逻辑)
        if (GLRenderSys.getInstance() != null) {
//            GLRenderSys.getInstance().resume();
//
//            if(isSuspend){
//                mSurfaceTextureListener.onSurfaceTextureAvailable(
//                        mInKeTestView.getTextureView().getSurfaceTexture(), 1080, 1920);
////                createOpenGlScene();
//                isSuspend = false;
//            }
        }
//
    }

    public void openCamera(boolean isFirst) {
        if (mCameraHasOpened) {
            return;
        }
        if (mCamera == null) {
            try {
                mCamera = Camera.open(Camera.CameraInfo.CAMERA_FACING_FRONT);
                if (mCamera == null) {
                    Log.e("shiyang", "shiyang cannot open camera");
                    return;
                }
                Camera.Parameters parameters = mCamera.getParameters();
                final List<String> focusModes = parameters.getSupportedFocusModes();
                // 连续聚焦
                if (focusModes.contains(Camera.Parameters.FOCUS_MODE_CONTINUOUS_VIDEO)) {
                    parameters.setFocusMode(Camera.Parameters.FOCUS_MODE_CONTINUOUS_VIDEO);
                }
                // 自动聚焦
                if (focusModes.contains(Camera.Parameters.FOCUS_MODE_AUTO)) {
                    parameters.setFocusMode(Camera.Parameters.FOCUS_MODE_AUTO);
                }
                parameters.setPreviewFormat(ImageFormat.NV21);

//                Camera.Size CameraSize = findBestPreviewResolution(parameters);
                Camera.Size defaultPreviewResolution = parameters.getPreviewSize();

                List<Camera.Size> rawSupportedSizes = parameters.getSupportedPreviewSizes();
//                if (CameraSize != null) {
                    parameters.setPreviewSize(1280, 720); //预览
//                    parameters.setPictureSize(CameraSize.width, CameraSize.height); //拍照
//                    previewSize[0] = CameraSize.width;
//                    previewSize[1] = CameraSize.height;
//                }

                //设置以最大帧率回调
                final List<int[]> supportedFpsRange = parameters.getSupportedPreviewFpsRange();
                if(supportedFpsRange != null && supportedFpsRange.size() > 0) {
                    final int[] fps = supportedFpsRange.get(supportedFpsRange.size() - 1);
                    int min = fps[0];
                    int max = fps[1];
                    parameters.setPreviewFpsRange(fps[0], fps[1]);
                }

                mCamera.setParameters(parameters);
                mCameraHasOpened = true;
                mCamera.setDisplayOrientation(mCameraDisplayOrientationDegree);
//                freeTexture();

                mCameraIsPreviewing = true;

                mTextures = new int[1];
                GLES20.glGenTextures(1, mTextures, 0);
                mCameraSurfaceTexture = new SurfaceTexture(mTextures[0]);

                mCamera.setPreviewTexture(mCameraSurfaceTexture);
                mCamera.startPreview();
                mCameraHasOpened = true;


                Camera.Size size = mCamera.getParameters().getPreviewSize();
                mCamera.setPreviewCallbackWithBuffer(mPreviewListener);
                int len = size.width * size.height *
                        ImageFormat.getBitsPerPixel(mCamera.getParameters().getPreviewFormat()) / 8;
                mCamera.addCallbackBuffer(new byte[len]);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    byte[] data_c = null;
    private Camera.PreviewCallback mPreviewListener = new Camera.PreviewCallback() {
        @Override
        public void onPreviewFrame(byte[] data, Camera camera) {
            if (camera == null) {
                Log.e("shiyang", "shiyang camera == null");
                return;
            }
            data_c = data;
            Camera.Parameters param = camera.getParameters();
            Camera.Size t_size = param.getPreviewSize();
            int width = t_size.width;
            int height = t_size.height;
            int size = width * height * 3 / 2;

            // pass preview data to Tracker and RenderFramework
            if (mCameraDataBuffer == null) {
                //分配空间
                mCameraDataBuffer = ByteBuffer.allocateDirect(size);
            }
            mCameraDataBuffer.rewind();
            mCameraDataBuffer.put(data_c);
//            nativeSetData(mCameraDataBuffer, mCameraDataBuffer.array().length);

            camera.addCallbackBuffer(data_c);
        }
    };

    private TextureView.SurfaceTextureListener mSurfaceTextureListener = new TextureView.SurfaceTextureListener() {
        @Override
        public void onSurfaceTextureAvailable(SurfaceTexture surface, int width, int height) {
            Log.d("shiyang", "shiyang onSurfaceTextureAvailable");
            GLRenderSys.getInstance().createSceneTextureView(surface, width, height, false);
        }

        @Override
        public void onSurfaceTextureSizeChanged(SurfaceTexture surfaceTexture, int i, int i1) {

        }

        @Override
        public boolean onSurfaceTextureDestroyed(SurfaceTexture surfaceTexture) {
            return false;
        }

        @Override
        public void onSurfaceTextureUpdated(SurfaceTexture surfaceTexture) {

        }
    };

    //JNI
    public static native void nativeInitRenderFramework();
//    public static native void nativeSetData(ByteBuffer buffer, int len);
}
