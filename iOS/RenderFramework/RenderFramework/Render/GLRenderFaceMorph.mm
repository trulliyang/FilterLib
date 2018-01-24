//
//  GLRenderFaceMorph.m
//  RenderFramework
//
//  Created by yang.SHI on 2017/8/3.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import "GLRenderFaceMorph.h"

@interface GLRenderFaceMorph(){

#define NEW_SLIM_NUM_VERTEX_PART1       101
#define NEW_SLIM_NUM_VERTEX_PART2       8
#define NEW_SLIM_NUM_VERTEX_PART3       19
#define NEW_SLIM_NUM_VERTEX             (NEW_SLIM_NUM_VERTEX_PART1+NEW_SLIM_NUM_VERTEX_PART2+NEW_SLIM_NUM_VERTEX_PART3)
#define NEW_SLIM_NUM_TRIANGLE_PART1     183
#define NEW_SLIM_NUM_TRIANGLE_PART2     38
#define NEW_SLIM_NUM_TRIANGLE           (NEW_SLIM_NUM_TRIANGLE_PART1+NEW_SLIM_NUM_TRIANGLE_PART2)
#define NEW_SLIM_NUM_INDEX              (NEW_SLIM_NUM_TRIANGLE*3)
#define NEW_SLIM_NUM_INDEX_PART2        (NEW_SLIM_NUM_TRIANGLE_PART2*3)
#define NEW_SLIM_NUM_VERTEX_XY          (NEW_SLIM_NUM_VERTEX*2)
#define MORPH_MAX_PERSON_NUM            1
#define SLIM_POINT_NUM                  8
#define NEW_SLIM_STRENGTH_DEFAULT       0.3f

#define NUM_AS_FACE_TRI                 183
#define NUM_AS_FACE_MESHVER             NUM_AS_FACE_TRI*3
    
    @public
    GLuint programID;
    GLuint textureID;
    
    GLuint originVertexID;
    GLuint originTexcoordID;
    GLuint originIndexID;
    
    GLuint morphVertexID;
    GLuint morphTexcoordID;
    GLuint morphIndexID;
    
    GLfloat   mNewVtxData[MORPH_MAX_PERSON_NUM][NEW_SLIM_NUM_VERTEX_XY];  // vertex coordinate data
    GLfloat   mNewTexData[MORPH_MAX_PERSON_NUM][NEW_SLIM_NUM_VERTEX_XY];  // texture coordinate data
    GLushort  mNewIdxData[MORPH_MAX_PERSON_NUM][NEW_SLIM_NUM_INDEX];      // index data
    GLboolean mNewHasFace[MORPH_MAX_PERSON_NUM];
    
    GLFramebufferObject *fbo;
    
    float mNewSlimStrength;
    bool mUseSmartSlim;
    
    GLuint fboID;
}
@end

////////////////GLRenderFaceMorph//////////////////////////
@implementation GLRenderFaceMorph
- (instancetype)init
{
    if (self = [super init])
    {
        programID = 0;
        textureID = 0;
        originVertexID = 0;
        originTexcoordID = 0;
        originIndexID = 0;
        morphVertexID = 0;
        morphTexcoordID = 0;
        morphIndexID = 0;
        [self initMesh];
        [self initFramebuffer];
    }
    return self;
}

- (void)setupProgramVertex:(NSString *)v Fragment:(NSString *)f;
{
    programID = createGLProgramFromFile(v.UTF8String, f.UTF8String);
    NSLog(@"GLRenderFaceMorph do setupProgram shader id = %d", programID);
//    glUseProgram(programID);
}

- (void)initMesh
{
    float v[8] = {-1,1,  1,1,  -1,-1,  1,-1};
    glGenBuffers(1, &originVertexID);
    glBindBuffer(GL_ARRAY_BUFFER, originVertexID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(v), v, GL_STATIC_DRAW);
    
    float t[8] = {0,1,  1,1,  0,0,  1,0};
    glGenBuffers(1, &originTexcoordID);
    glBindBuffer(GL_ARRAY_BUFFER, originTexcoordID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(t), t, GL_STATIC_DRAW);
    
    unsigned short i[6] = {0,1,2, 1,2,3};
    glGenBuffers(1, &originIndexID);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, originIndexID);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(i), i, GL_STATIC_DRAW);
    
    const unsigned short as_mesh[NUM_AS_FACE_MESHVER] =
    {
        0,1,39,
        1,2,50,
        2,3,49,
        3,4,48,
        4,5,66,
        5,6,67,
        6,7,86,
        7,8,85,
        8,9,84,
        9,10,84,
        10,11,83,
        11,12,82,
        12,13,70,
        13,14,71,
        14,15,60,
        15,16,59,
        16,17,58,
        17,18,57,
        18,34,57,
        34,35,57,
        35,36,56,
        36,37,55,
        37,38,54,
        38,29,53,
        29,74,52,
        74,73,51,
        73,72,51,
        72,71,62,
        71,14,61,
        51,72,62,
        62,71,61,
        61,14,60,
        60,15,59,
        59,16,58,
        58,17,57,
        57,35,56,
        56,36,55,
        55,37,54,
        54,38,53,
        53,29,52,
        52,74,51,
        51,62,96,
        62,61,96,
        61,60,96,
        60,59,96,
        59,58,96,
        58,57,96,
        57,56,96,
        56,55,96,
        55,54,96,
        54,53,96,
        53,52,96,
        52,51,96,
        35,34,33,
        36,35,33,
        36,33,32,
        37,36,32,
        37,32,31,
        38,37,31,
        38,31,30,
        29,38,30,
        23,29,30,
        23,24,29,
        24,97,29,
        97,74,29,
        97,98,74,
        98,73,74,
        98,72,73,
        98,99,72,
        99,71,72,
        99,70,71,
        99,69,70,
        99,100,69,
        99,68,100,
        99,67,68,
        99,66,67,
        99,65,66,
        99,98,65,
        64,65,98,
        63,64,98,
        63,98,97,
        24,63,97,
        71,70,13,
        70,81,12,
        70,80,81,
        80,70,69,
        69,79,80,
        100,79,69,
        100,78,79,
        100,77,78,
        68,77,100,
        68,76,77,
        67,76,68,
        67,75,76,
        67,6,75,
        75,6,86,
        7,85,86,
        8,84,85,
        10,83,84,
        11,82,83,
        12,81,82,
        75,86,87,
        86,94,87,
        86,85,94,
        85,93,94,
        85,84,93,
        84,83,93,
        83,92,93,
        83,82,92,
        82,91,92,
        82,81,91,
        81,80,91,
        80,90,91,
        90,80,79,
        89,90,79,
        89,79,78,
        89,78,77,
        88,89,77,
        88,76,87,
        88,77,76,
        75,87,76,
        5,67,66,
        4,66,47,
        4,47,48,
        66,46,47,
        66,65,46,
        65,45,46,
        65,64,45,
        64,63,45,
        63,44,45,
        63,24,44,
        24,43,44,
        24,25,43,
        25,42,43,
        25,26,42,
        26,41,42,
        26,27,41,
        27,40,41,
        27,28,40,
        28,39,40,
        28,19,39,
        19,0,39,
        39,1,50,
        2,49,50,
        3,48,49,
        95,40,39,
        95,41,40,
        95,42,41,
        95,43,42,
        95,44,43,
        95,45,44,
        95,46,45,
        95,47,46,
        95,48,47,
        95,49,48,
        95,50,49,
        95,39,50,
        25,24,23,
        25,23,22,
        26,25,22,
        26,22,21,
        27,26,21,
        27,21,20,
        28,27,20,
        28,20,19,
        101,19,0,
        101,20,19,
        101,102,20,
        102,103,21,
        20,102,21,
        21,103,22,
        103,23,22,
        103,104,23,
        105,106,30,
        30,106,31,
        31,106,32,
        106,107,32,
        32,107,33,
        107,108,33,
        33,108,34,
        34,108,18,
        104,105,30,
        104,30,23
        
    };
    
    for (int mp = 0; mp < MORPH_MAX_PERSON_NUM; mp++) {
        mNewHasFace[mp] = false;
        
        // init triangles indices
        for (int i = 0; i < NUM_AS_FACE_MESHVER; i++) {
            mNewIdxData[mp][i] = as_mesh[i];
        }
        
        // reorganise some indices of the corner of mouth
        int t_index[12] = {15, 16, 17, 282, 283, 284, 249, 250, 251, 36, 37, 38};
        unsigned short t_value[12] = {5, 67, 75, 5, 6, 75, 70, 81, 13, 81, 12, 13};
        for (int i = 0; i < 12; i++) {
            mNewIdxData[mp][t_index[i]] = t_value[i];
        }
        
        unsigned short t_indexInitial[NEW_SLIM_NUM_INDEX_PART2] = {
            109, 101, 0,
            110, 109, 0, 111, 110, 1, 112, 111, 2, 113, 112, 3, 114, 113, 4, 115, 114,
            5, 116, 115, 6, 117, 116, 7, 118, 117, 8, 119, 118, 9, 120, 119, 10, 121, 120, 11,
            122, 121, 12, 123, 122, 13, 124, 123, 14, 125, 124, 15, 126, 125, 16, 127, 126, 17,
            0, 1, 110, 1, 2, 111, 2, 3, 112, 3, 4, 113, 4, 5, 114, 5, 6, 115,
            6, 7, 116, 7, 8, 117, 8, 9, 118, 9, 10, 119, 10, 11, 120, 11, 12, 121,
            12, 13, 122, 13, 14, 123, 14, 15, 124, 15, 16, 125, 16, 17, 126, 17, 18, 127,
            18, 108, 127
        };
        
        unsigned short t_indexNewMouth[20 * 3] = {
            75, 76, 93, 76, 77, 93, 77, 78, 93, 78, 79, 93, 79, 80, 93, 80, 81, 93,
            81, 82, 93, 82, 83, 93, 83, 84, 93, 84, 85, 93, 85, 86, 93, 86, 75, 93,
            
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        };
        
        for (int i = 0; i < 20 * 3; i++) {
            mNewIdxData[mp][i + 303] = t_indexNewMouth[i];
        }
        
        for (int i = 0; i < NEW_SLIM_NUM_INDEX_PART2; i++) {
            mNewIdxData[mp][i + NUM_AS_FACE_MESHVER] = t_indexInitial[i];
        }
        
        unsigned int t_len = NEW_SLIM_NUM_VERTEX_XY * sizeof(float);
        t_len = NEW_SLIM_NUM_INDEX * sizeof(unsigned short);
    }
    
    memset(mNewVtxData, 0, sizeof(mNewVtxData));
    memset(mNewTexData, 0, sizeof(mNewTexData));
    
    glGenBuffers(1, &morphVertexID);
    glBindBuffer(GL_ARRAY_BUFFER, morphVertexID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(mNewVtxData), mNewVtxData, GL_DYNAMIC_DRAW);
    
    glGenBuffers(1, &morphTexcoordID);
    glBindBuffer(GL_ARRAY_BUFFER, morphTexcoordID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(mNewTexData), mNewTexData, GL_DYNAMIC_DRAW);
    
    glGenBuffers(1, &morphIndexID);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, morphIndexID);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(mNewIdxData), mNewIdxData, GL_STATIC_DRAW);
    
    mNewSlimStrength = NEW_SLIM_STRENGTH_DEFAULT;
    mUseSmartSlim = true;
}

- (void)initFramebuffer
{
    fbo = [[GLFramebufferObject alloc] init];
    NSLog(@"fbo id = %d, fbo texture id = %d", [fbo getFBOID], [fbo getFBOTextureID]);
}

- (void)setTrackerData:(FPOINT *)points pointNum:(int)ptNumber faceNum:(int)faceNumber Width:(int)width Height:(int)height
{
    //    NSLog(@"RenderFramework do setTrackerData");
    //    NSLog(@"render w = %d h = %d", width, height);
    if (faceNumber > 0) {
        mNewHasFace[0] = true;
        //        NSLog(@"RenderFramework do setTrackerData ptNumber = %d, faceNumber = %d", ptNumber, faceNumber);
        int pNum = ptNumber;
        FPOINT fp[pNum];
        memcpy(fp, points, sizeof(FPOINT)*pNum);
        //        NSLog(@"render p9x=%d, p9y=%d", fp[9].x, fp[9].y);
        
        float w_rev = 1.0f/(float)width;
        float h_rev = 1.0f/(float)height;
        
        mNewVtxData[0][97*2+0] = 2.0f*((float)fp[97].x*w_rev)-1.0f;
        mNewVtxData[0][97*2+1] = 2.0f*((float)fp[97].y*h_rev)-1.0f;
        for (int i=0; i<101; i++) {
            mNewVtxData[0][i*2+0] = 2.0f*((float)fp[i].x*w_rev)-1.0f;
            mNewVtxData[0][i*2+1] = 2.0f*((float)fp[i].y*h_rev)-1.0f;
            
            if (87<=i && i<=94) {
                mNewVtxData[0][i*2+0] = 2.0f*((float)fp[93].x*w_rev)-1.0f;
                mNewVtxData[0][i*2+1] = 2.0f*((float)fp[93].y*h_rev)-1.0f;
            }
            
            if (i<19) {
                mNewVtxData[0][(i+109)*2+0] = mNewVtxData[0][i*2+0] -
                                              (mNewVtxData[0][97*2+0] - mNewVtxData[0][i*2+0])*0.3f;
                mNewVtxData[0][(i+109)*2+1] = mNewVtxData[0][i*2+1] -
                                              (mNewVtxData[0][97*2+1] - mNewVtxData[0][i*2+1])*0.3f;
            }
        }
        
        mNewVtxData[0][101*2+0] = 2.0f*((float)fp[19].x*w_rev)-1.0f;
        mNewVtxData[0][101*2+1] = 2.0f*((float)fp[19].y*h_rev)-1.0f;
        
        mNewVtxData[0][102*2+0] = 2.0f*((float)fp[21].x*w_rev)-1.0f;
        mNewVtxData[0][102*2+1] = 2.0f*((float)fp[21].y*h_rev)-1.0f;
        
        mNewVtxData[0][103*2+0] = 2.0f*((float)fp[22].x*w_rev)-1.0f;
        mNewVtxData[0][103*2+1] = 2.0f*((float)fp[22].y*h_rev)-1.0f;
        
        mNewVtxData[0][104*2+0] = 2.0f*((float)fp[23].x*w_rev)-1.0f;
        mNewVtxData[0][104*2+1] = 2.0f*((float)fp[23].y*h_rev)-1.0f;
        
        mNewVtxData[0][105*2+0] = 2.0f*((float)fp[30].x*w_rev)-1.0f;
        mNewVtxData[0][105*2+1] = 2.0f*((float)fp[30].y*h_rev)-1.0f;
        
        mNewVtxData[0][106*2+0] = 2.0f*((float)fp[31].x*w_rev)-1.0f;
        mNewVtxData[0][106*2+1] = 2.0f*((float)fp[31].y*h_rev)-1.0f;
        
        mNewVtxData[0][107*2+0] = 2.0f*((float)fp[32].x*w_rev)-1.0f;
        mNewVtxData[0][107*2+1] = 2.0f*((float)fp[32].y*h_rev)-1.0f;
        
        mNewVtxData[0][108*2+0] = 2.0f*((float)fp[34].x*w_rev)-1.0f;
        mNewVtxData[0][108*2+1] = 2.0f*((float)fp[34].y*h_rev)-1.0f;
        
        for (int i=0; i<NEW_SLIM_NUM_VERTEX_XY; i+=2) {
            mNewTexData[0][i+0] = mNewVtxData[0][i+0]*0.5f+0.5f;
            mNewTexData[0][i+1] = mNewVtxData[0][i+1]*0.5f+0.5f;
        }
        
        glBindBuffer(GL_ARRAY_BUFFER, morphVertexID);
        glBufferData(GL_ARRAY_BUFFER, sizeof(mNewVtxData), mNewVtxData, GL_DYNAMIC_DRAW);
        
        glBindBuffer(GL_ARRAY_BUFFER, morphTexcoordID);
        glBufferData(GL_ARRAY_BUFFER, sizeof(mNewTexData), mNewTexData, GL_DYNAMIC_DRAW);
        
        // do left
        //get line 1 to 9: Ax+By+C = 0 or y=kx+b
        
        float A = 1.0f;
        float B = 1.0f;
        float C = 1.0f;
        float M = 0.0f;
        float p1x = (float)fp[1].x;
        float p1y = (float)fp[1].y;
        float p8x = (float)fp[8].x;
        float p8y = (float)fp[8].y;
        float v1to8[2] = {p8x-p1x, p8y-p1y};
        float verticalpx[SLIM_POINT_NUM];
        float verticalpy[SLIM_POINT_NUM];
        float distance[SLIM_POINT_NUM];
        float sumDistanceLeft = 0.0f;
        float distance1to8 = sqrtf(v1to8[0]*v1to8[0]+v1to8[1]*v1to8[1]);
        float morphpx[SLIM_POINT_NUM];
        float morphpy[SLIM_POINT_NUM];
        float alpha = mNewSlimStrength;
        float beta = 1.0f;
        
        //    printf("alpha=%f\n", alpha);
        
        if (0.0 == v1to8[0]) {// y-aixs parallel
            A = 1.0f;
            B = 0.0f;
            C = -p1x;
            for (int i=0; i<SLIM_POINT_NUM; i++) {
                verticalpx[i] = p1x;
                verticalpy[i] = (float)fp[(i+1)].y;
                distance[i] = fabsf((float)fp[(i+1)].x - verticalpx[i]);
                sumDistanceLeft += distance[i];
            }
        } else if (0.0 == v1to8[1]) {
            A = 0.0f;
            B = 1.0f;
            C = -p1y;
            for (int i=0; i<SLIM_POINT_NUM; i++) {
                verticalpx[i] = (float)fp[(i+1)].x;
                verticalpy[i] = p1y;
                distance[i] = fabsf((float)fp[(i+1)].y - verticalpy[i]);
                sumDistanceLeft += distance[i];
            }
        } else {
            A = 1.0f/v1to8[0];
            B = -1.0f/v1to8[1];
            C = -p8x/v1to8[0] + p8y/v1to8[1];
            // get the vertical straight line: Bx-Ay+M = 0
            for (int i=0; i<SLIM_POINT_NUM; i++) {
                M = A*(float)fp[(i+1)].y - B*(float)fp[(i+1)].x;
                verticalpx[i] = -(A*C+B*M)/(A*A+B*B);
                verticalpy[i] = (A*M-B*C)/(B*B+A*A);
                float dx = (float)fp[(i+1)].x - verticalpx[i];
                float dy = (float)fp[(i+1)].y - verticalpy[i];
                distance[i] = sqrtf(dx*dx+dy*dy);
                sumDistanceLeft += distance[i];
            }
        }
        
        //        printf("left distance1to8=%f, sumDistanceLeft=%f\n", distance1to8, sumDistanceLeft);
        
        if (mUseSmartSlim) {
            beta = distance1to8/sumDistanceLeft;
            float betaThresholdUp = 2.5f;//1.5;
            float betaThresholdDown = 1.5f;//1.1;
            if (beta >= betaThresholdUp) {
                alpha = 0.0f;
            } else if (beta > betaThresholdDown) {
                alpha *= (betaThresholdUp-beta)/(betaThresholdUp-betaThresholdDown);
            } else {
                // do nothing
            }
        }
        
        for (int i=0; i<SLIM_POINT_NUM; i++) {
            morphpx[i] = (1.0f-alpha)*(float)fp[(i+1)].x + alpha*verticalpx[i];
            morphpy[i] = (1.0f-alpha)*(float)fp[(i+1)].y + alpha*verticalpy[i];
            
            mNewVtxData[0][(i+1)*2+0] = 2.0f*(morphpx[i]*w_rev)-1.0f;
            mNewVtxData[0][(i+1)*2+1] = 2.0f*(morphpy[i]*h_rev)-1.0f;
        }
        
        // do right
        //get line 10 to 17: Ax+By+C = 0 or y=kx+b
        A = 1.0f;
        B = 1.0f;
        C = 1.0f;
        M = 0.0f;
        float p17x = (float)fp[17].x;
        float p17y = (float)fp[17].y;
        float p10x = (float)fp[10].x;
        float p10y = (float)fp[10].y;
        float v17to10[2] = {p10x-p17x, p10y-p17y};
        float distance17to10 = sqrtf(v17to10[0]*v17to10[0] + v17to10[1]*v17to10[1]);
        float sumDistanceRight = 0;
        
        memset(verticalpx, 0, sizeof(verticalpx));
        memset(verticalpy, 0, sizeof(verticalpy));
        memset(distance, 0, sizeof(distance));
        memset(morphpx, 0, sizeof(morphpx));
        memset(morphpy, 0, sizeof(morphpy));
        alpha = mNewSlimStrength;
        
        if (0.0 == v17to10[0]) {
            A = 1.0f;
            B = 0.0f;
            C = -p17x;
            for (int i=0; i<SLIM_POINT_NUM; i++) {
                verticalpx[i] = p17x;
                verticalpy[i] = (float)fp[(i+17)].y;
                distance[i] = fabsf((float)fp[(i+17)].x - verticalpx[i]);
                sumDistanceRight += distance[i];
            }
        } else if (0.0 == v17to10[1]) {
            A = 0.0f;
            B = 1.0f;
            C = -p17y;
            for (int i=0; i<SLIM_POINT_NUM; i++) {
                verticalpx[i] = (float)fp[(i+17)].x;
                verticalpy[i] = p17y;
                distance[i] = fabsf((float)fp[(i+17)].y - verticalpy[i]);
                sumDistanceRight += distance[i];
            }
        } else {
            A = 1.0f/v17to10[0];
            B = -1.0f/v17to10[1];
            C = -p10x/v17to10[0] + p10y/v17to10[1];
            // get the vertical straight line: Bx-Ay+M = 0
            for (int i=0; i<SLIM_POINT_NUM; i++) {
                M = A*(float)fp[(i+10)].y - B*(float)fp[(i+10)].x;
                verticalpx[i] = -(A*C+B*M)/(A*A+B*B);
                verticalpy[i] = (A*M-B*C)/(B*B+A*A);
                float dx = (float)fp[(i+10)].x - verticalpx[i];
                float dy = (float)fp[(i+10)].y - verticalpy[i];
                distance[i] = sqrtf(dx*dx+dy*dy);
                sumDistanceRight += distance[i];
            }
        }
        
        //    printf("RIGHT distance17to9=%f, sumDistanceRight=%f\n", distance17to9, sumDistanceRight);
        if (mUseSmartSlim) {
            beta = distance17to10/sumDistanceRight;
            float betaThresholdUp = 2.5f;//1.5;
            float betaThresholdDown = 1.5f;//1.1;
            if (beta >= betaThresholdUp) {
                alpha = 0.0;
            } else if (beta > betaThresholdDown) {
                alpha *= (betaThresholdUp-beta)/(betaThresholdUp-betaThresholdDown);
            } else {
                // do nothing
            }
        }
        
        for (int i=0; i<SLIM_POINT_NUM; i++) {
            morphpx[i] = (1.0f-alpha)*(float)fp[(i+10)].x + alpha*verticalpx[i];
            morphpy[i] = (1.0f-alpha)*(float)fp[(i+10)].y + alpha*verticalpy[i];
            
            mNewVtxData[0][(i+10)*2+0] = 2.0f*(morphpx[i]*w_rev)-1.0f;
            mNewVtxData[0][(i+10)*2+1] = 2.0f*(morphpy[i]*h_rev)-1.0f;
        }
        
        glBindBuffer(GL_ARRAY_BUFFER, morphVertexID);
        glBufferData(GL_ARRAY_BUFFER, sizeof(mNewVtxData), mNewVtxData, GL_DYNAMIC_DRAW);
    } else {
        //        NSLog(@"RenderFramework do setTrackerData no face");
    }
}

- (void)setTextureRGBA:(GLTextureRGBA *)texture
{
}

- (void)setTextureId:(GLuint)texId
{
    textureID = texId;
//    NSLog(@"GLRenderFaceMorph setTextureId = %d", texId);
}

- (GLTextureRGBA *)getTexture
{
    return nil;
}

- (GLuint)getTextureId
{
    return 0;
}

- (void)setFBOId:(GLuint)fboid
{
    fboID = fboid;
}

- (GLuint)getFBOId
{
    return [fbo getFBOID];
}

- (GLuint)getFBOTextureId
{
    return [fbo getFBOTextureID];
}

- (void)prepareRender
{
    bool notLast = true;
    GLuint fbid = [fbo getFBOID];
    
    glUseProgram(programID);
    
    if (notLast) {
        glBindFramebuffer(GL_FRAMEBUFFER, fbid);
    } else {
        glBindFramebuffer(GL_FRAMEBUFFER, fboID);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, 1);
    }
    glViewport(0, 0, 720, 1280);
//    glViewport(0, 0, 375, 667);
    glClearColor(0.0f, 1.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureID);
    glUniform1i(glGetUniformLocation(programID, "image0"), 0);
    
    glUniform1i(glGetUniformLocation(programID, "isRGBA"), 1);
    glUniform1f(glGetUniformLocation(programID, "rotationDegree"), 0.0);
    
    //绘图
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    //顶点流
    glBindBuffer(GL_ARRAY_BUFFER, originVertexID);
    glEnableVertexAttribArray(glGetAttribLocation(programID, "position"));
    glVertexAttribPointer(glGetAttribLocation(programID, "position"), 2, GL_FLOAT, GL_FALSE, 0, NULL);
    
    //纹理坐标流
    glBindBuffer(GL_ARRAY_BUFFER, originTexcoordID);
    glEnableVertexAttribArray(glGetAttribLocation(programID, "texcoord"));
    glVertexAttribPointer(glGetAttribLocation(programID, "texcoord"), 2, GL_FLOAT,GL_FALSE, 0, NULL);
    
    //索引方式绘制
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, originIndexID);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, 0);//NUM_INDEX
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    glDisableVertexAttribArray(glGetAttribLocation(programID, "position"));
    glDisableVertexAttribArray(glGetAttribLocation(programID, "texcoord"));
    
    glUseProgram(0);
    
    glDisable(GL_BLEND);
    
    if (mNewHasFace[0]) {
        //        NSLog(@"RenderFramework do prepareRender render face");
        glUseProgram(programID);

//            GLuint fbid = [fbo getFBOID];
        if (notLast) {
            glBindFramebuffer(GL_FRAMEBUFFER, fbid);
        } else {
            glBindFramebuffer(GL_FRAMEBUFFER, fboID);
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, 1);
        }
        
//
        glViewport(0, 0, 720, 1280);
//        glViewport(0, 0, 1280, 720);
//        glViewport(0, 0, 375, 667);
//        glClearColor(0.0f, 1.0f, 0.0f, 1.0f);
//        glClear(GL_COLOR_BUFFER_BIT);
        
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, textureID);
        glUniform1i(glGetUniformLocation(programID, "image0"), 0);
        
        glUniform1i(glGetUniformLocation(programID, "isRGBA"), 1);
        glUniform1f(glGetUniformLocation(programID, "rotationDegree"), 0.0);
        
        //绘图
        glEnable(GL_BLEND);
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        
        //顶点流
        glBindBuffer(GL_ARRAY_BUFFER, morphVertexID);
        glEnableVertexAttribArray(glGetAttribLocation(programID, "position"));
        glVertexAttribPointer(glGetAttribLocation(programID, "position"), 2, GL_FLOAT, GL_FALSE, 0, NULL);
        
        //纹理坐标流
        glBindBuffer(GL_ARRAY_BUFFER, morphTexcoordID);
        glEnableVertexAttribArray(glGetAttribLocation(programID, "texcoord"));
        glVertexAttribPointer(glGetAttribLocation(programID, "texcoord"), 2, GL_FLOAT,GL_FALSE, 0, NULL);
        
        //索引方式绘制
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, morphIndexID);
        glDrawElements(GL_TRIANGLES, NEW_SLIM_NUM_INDEX, GL_UNSIGNED_SHORT, 0);//NUM_INDEX
        
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        
        glDisableVertexAttribArray(glGetAttribLocation(programID, "position"));
        glDisableVertexAttribArray(glGetAttribLocation(programID, "texcoord"));
        
        glUseProgram(0);
        
        glDisable(GL_BLEND);
        
        mNewHasFace[0] = false;
    }
}

- (void)afterRender
{
}
@end
