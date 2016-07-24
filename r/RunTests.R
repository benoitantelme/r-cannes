library('RUnit')
source("r/Utils.R")



utilsTestSuite <- defineTestSuite("Utils tests",
                                  dirs = "test",
                                  testFileRegexp = '^\\w+\\.R')


utilsTestResult <- runTestSuite(utilsTestSuite)



printTextProtocol(utilsTestResult)
