cpa /32g_m_One10/* . && { echo 'exit code from cpa was '$? ; bdiff /32g_m_One10 . ; } 2>&1 | tee /ram/bdiff 
