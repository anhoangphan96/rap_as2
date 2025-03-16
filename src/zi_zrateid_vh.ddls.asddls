@AbapCatalog.sqlViewName: 'ZRATEIDVALUEHELP'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Zrateid Value help'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_zrateid_VH as select from ZI_AS2_ZRATENAME  left outer join ZI_AS2_ZRATEDATA
                                            on ZI_AS2_ZRATENAME.Zrateid = ZI_AS2_ZRATEDATA.Zrateid
{
    key ZI_AS2_ZRATEDATA.Bukrs as bukrs,
    @EndUserText.label: 'ID of Rate'
    key ZI_AS2_ZRATENAME.Zrateid as zrateid,
    @EndUserText.label: 'Name of Rate'
    ZI_AS2_ZRATENAME.Zratename as ztratename,
    @EndUserText.label: 'Abbereviation name of Rate'
    ZI_AS2_ZRATENAME.Zabbreviation as zabbreviation,
    @EndUserText.label: 'Reexamince cycle'
    ZI_AS2_ZRATENAME.Zcycle as zcycle,
    @EndUserText.label: 'Spread zone'
    ZI_AS2_ZRATENAME.Zzone as  zzone
}
