// Assign Portfolio Field Access permission set to the running user
List<PermissionSet> psList = [SELECT Id FROM PermissionSet WHERE Name = 'Portfolio_Field_Access' LIMIT 1];
if (!psList.isEmpty()) {
    List<PermissionSetAssignment> existing = [
        SELECT Id FROM PermissionSetAssignment
        WHERE AssigneeId = :UserInfo.getUserId()
        AND PermissionSetId = :psList[0].Id
        LIMIT 1
    ];
    if (existing.isEmpty()) {
        insert new PermissionSetAssignment(
            AssigneeId = UserInfo.getUserId(),
            PermissionSetId = psList[0].Id
        );
        System.debug('Permission set assigned to: ' + UserInfo.getUserName());
    } else {
        System.debug('Permission set already assigned.');
    }
} else {
    System.debug('Permission set Portfolio_Field_Access not found.');
}
