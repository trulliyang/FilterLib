cmake_minimum_required(VERSION 3.4.1)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall")

add_library(
             native-lib
             SHARED

             src/main/cpp/native-lib.cpp

             src/main/cpp/FLJNI.cpp
             src/main/cpp/FLJNI.h

             src/main/cpp/com_jnirenderer_RendererJNI.cpp
             src/main/cpp/com_jnirenderer_RendererJNI.h

             src/main/cpp/RenderFramework/FrameBufferObject/GLFrameBufferObject.cpp
             src/main/cpp/RenderFramework/FrameBufferObject/GLFrameBufferObject.h
             src/main/cpp/RenderFramework/Base/GLBase.h
             src/main/cpp/RenderFramework/Base/LogBase.h
             src/main/cpp/RenderFramework/Render/GLRender.cpp
             src/main/cpp/RenderFramework/Render/GLRender.h
             src/main/cpp/RenderFramework/Render/GLRenderFirst.cpp
             src/main/cpp/RenderFramework/Render/GLRenderFirst.h
             src/main/cpp/RenderFramework/Render/GLRenderYUV.cpp
             src/main/cpp/RenderFramework/Render/GLRenderYUV.h
             src/main/cpp/RenderFramework/Render/GLRenderLast.cpp
             src/main/cpp/RenderFramework/Render/GLRenderLast.h
             src/main/cpp/RenderFramework/Render/GLRenderSys.cpp
             src/main/cpp/RenderFramework/Render/GLRenderSys.h
             src/main/cpp/RenderFramework/Texture/GLTextureData.cpp
             src/main/cpp/RenderFramework/Texture/GLTextureData.h
             src/main/cpp/RenderFramework/Utils/FrameBufferObjectUtils.cpp
             src/main/cpp/RenderFramework/Utils/FrameBufferObjectUtils.h
             src/main/cpp/RenderFramework/Utils/ShaderUtils.cpp
             src/main/cpp/RenderFramework/Utils/ShaderUtils.h
             src/main/cpp/RenderFramework/Utils/TextureUtils.cpp
             src/main/cpp/RenderFramework/Utils/TextureUtils.h

             src/main/cpp/Tracker/Tracker.cpp
             src/main/cpp/Tracker/Tracker.h
             )

find_library(
              log-lib
              log )

target_link_libraries(
                       native-lib
                       GLESv3
                       android
                       EGL
                       z
                       ${log-lib} )