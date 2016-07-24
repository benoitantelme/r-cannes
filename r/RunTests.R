library('RUnit')
source("r/Utils.R")

# take the R test files in test directory
utilsTestSuite <- defineTestSuite("Utils tests",
                                  dirs = "test",
                                  testFileRegexp = '^\\w+\\.R')

utilsTestResult <- runTestSuite(utilsTestSuite)
printTextProtocol(utilsTestResult)
