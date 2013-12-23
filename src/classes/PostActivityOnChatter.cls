global interface PostActivityOnChatter {
	
	list<sObject> whoIdObjectList(string Id);
	list<sObject> whatIdObjectList(string Id);
	void postDescriptionToChatter(list<sObject> listSobj);
	void followActivityOnChatter(list<string> Ids);
	void insertRecordInCustomSetting();

}