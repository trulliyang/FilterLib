//
// Created by SHI.yang on 2017/9/6.
//

#include "Tracker.h"

static Tracker *m_pInst = nullptr;

Tracker *Tracker::getInstance()
{
    if (nullptr == m_pInst) {
        m_pInst = new Tracker();
    }
    return m_pInst;
}

void Tracker::setData(unsigned char *_data, int _len)
{

}