global class VWCaseCreatorSOAPWS{
    webservice static String logACase(String caseSubject, String caseDescription){
    	Case tempCase = new Case();
        
        tempCase.Origin = 'Web';
        tempCase.Status = 'Working';
        tempCase.Reason = 'Installation';
        tempCase.Subject = caseSubject;
		tempCase.Description = caseDescription;
                
        insert tempCase;
        return tempCase.CaseNumber;
    }
}