package sy.filterlib;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;

/**
 *
 *
 * Created by SHI.yang on 2017/9/13.
 */

public class FLActivity extends Activity {

    private FLGLSurfaceView mFLGLSurfaceView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_fl);

        mFLGLSurfaceView = findViewById(R.id.fl_gl_surfaceView);
    }

    @Override
    protected void onResume() {
        super.onResume();
        mFLGLSurfaceView.onResume();
    }

    @Override
    protected void onPause() {
        super.onPause();
        mFLGLSurfaceView.onPause();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mFLGLSurfaceView.release();
    }
}

