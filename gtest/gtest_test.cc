/*
 * Tests for zrt
 *  Author: YaroslavLitvinov
 *  Date: 26.07.2012
 */

#include <stdio.h>

#define GTEST
#ifdef GTEST
#include "gtest/gtest.h"

// Test harness for routines in zmq_netw.c
class ZrtTests : public ::testing::Test {
public:
	ZrtTests(){}
};


TEST_F(ZrtTests, TestEnvironment) {
	//EXPECT_EQ( 0, 0 );
}
#endif


int main(int argc, char **argv) {
#ifdef GTEST
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
#endif
    return 0;
}

