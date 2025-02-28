@AbapCatalog.sqlViewName: 'ZZCDS_MYTEKXTEAM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'data definition for mytekx team'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_Mytekxteam as select from zrap_mytekxteam1
{
    key id as Id,
    firstname as Firstname,
    lastname as Lastname,
    age as Age,
    role as Role,
    salary as Salary,
    active as Active,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at as LocalLastChangedAt
}
