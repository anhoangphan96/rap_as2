CLASS zcl_concat_header DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES IF_SADL_EXIT_CALC_ELEMENT_READ.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_concat_header IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA lt_data TYPE STANDARD TABLE OF zc_as2_zratedata.

    lt_data =  CORRESPONDING #( it_original_data ).
    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<lfs_data>).
        IF <lfs_data>-Zrateid IS NOT INITIAL.
            <lfs_data>-HeaderText = |{ <lfs_data>-Bukrs }-{ <lfs_data>-Zrateid }-{ <lfs_data>-ZeffectDate }|.
        ELSE.
            <lfs_data>-HeaderText = ''.
        ENDIF.
    ENDLOOP.

   ct_calculated_data = CORRESPONDING #( lt_data ) .



  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.

ENDCLASS.
