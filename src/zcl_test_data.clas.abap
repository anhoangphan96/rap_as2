CLASS zcl_test_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_test_data IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*    SELECT *
*    FROM ztratename
*    INTO TABLE @DATA(lt_data).
*    DELETE ztratename from TABLE @lt_data.
*    TRY.
*        cl_numberrange_intervals=>create(
*      EXPORTING interval  = VALUE #( ( nrrangenr = '01' fromnumber = '1000000000' tonumber = '9999999999' procind = 'I' ) )
*                object    = 'ZNRZRATEID'
*      IMPORTING error     = data(ld_error)
*                error_inf = data(ls_error)
*                error_iv  = data(lt_error_iv)
*                warning   = data(ld_warning) ).
*      CATCH cx_number_ranges.
*        "handle exception
*    ENDTRY.
    DATA: ls_bukrs TYPE ZTBUKRS,
          lt_bukrs TYPE STANDARD TABLE OF ZTBUKRS.
    ls_bukrs-bukrs = 'C100'.
    ls_bukrs-butxt = 'ANPH US'.
    ls_bukrs-ort01 = 'Chicago'.
    ls_bukrs-spras = 'E'.
    ls_bukrs-ktopl = '1030'.
    ls_bukrs-waers = 'USD'.
    ls_bukrs-periv = 'C2'.
    ls_bukrs-aedat = ls_bukrs-erdat = cl_abap_context_info=>get_system_date( ).
    ls_bukrs-aenam = ls_bukrs-ernam = cl_abap_context_info=>get_user_technical_name(  ).
    GET TIME STAMP FIELD ls_bukrs-last_change_at .

    APPEND ls_bukrs TO lt_bukrs.

    ls_bukrs-bukrs = 'C200'.
    ls_bukrs-butxt = 'ANPH GE'.
    ls_bukrs-ort01 = 'Hamburg'.
    ls_bukrs-spras = 'D'.
    ls_bukrs-ktopl = '1100'.
    ls_bukrs-waers = 'EUR'.
    ls_bukrs-periv = '24'.
    ls_bukrs-aedat = ls_bukrs-erdat = cl_abap_context_info=>get_system_date( ).
    ls_bukrs-aenam = ls_bukrs-ernam = cl_abap_context_info=>get_user_technical_name(  ).
    GET TIME STAMP FIELD ls_bukrs-last_change_at .

    APPEND ls_bukrs TO lt_bukrs.
    MODIFY ZTBUKRS FROM TABLE  @lt_bukrs.



  ENDMETHOD.
ENDCLASS.
