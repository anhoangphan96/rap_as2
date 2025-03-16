@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interest Rate Name View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_AS2_ZRATENAME as select from ztratename
composition [0..*] of ZI_AS2_ZRATEDATA as _RateData
{
    key zzid as ID,
    zrateid as Zrateid,
    zrateid as Zrateid2,
    zratename as Zratename,
    zabbreviation as Zabbreviation,
    zcycle as Zcycle,
    zzone as Zzone,
    erdat as Erdat,
    @Semantics.user.createdBy: true
    ernam as Ernam,
    aedat as Aedat,
    @Semantics.user.lastChangedBy: true
    aenam as Aenam,
    @Semantics.systemDateTime.lastChangedAt: true
    last_change_at as LastChangeAt,
    _RateData // Make association public
}
