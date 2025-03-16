CLASS lhc_ratedata DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR RateData RESULT result.
    METHODS checkburks FOR VALIDATE ON SAVE
      IMPORTING keys FOR ratedata~checkburks.
    METHODS checkratedata FOR VALIDATE ON SAVE
      IMPORTING keys FOR ratedata~checkratedata.

ENDCLASS.

CLASS lhc_ratedata IMPLEMENTATION.

  METHOD get_instance_features.
    DATA result_line LIKE LINE OF result.
    DATA keys_of_active_instances TYPE TABLE FOR INSTANCE FEATURES KEY zi_as2_zratedata.

    LOOP AT keys INTO DATA(key).


      CLEAR keys_of_active_instances.
      APPEND INITIAL LINE TO  keys_of_active_instances.

      keys_of_active_instances[ 1 ]-%tky = key-%tky.
      "change the %is_draft flag to read only the active instance
      keys_of_active_instances[ 1 ]-%is_draft = if_abap_behv=>mk-off.

      result_line-%tky = key-%tky.

      READ ENTITIES OF zi_as2_zratename IN LOCAL MODE
            ENTITY RateData
              FIELDS ( Bukrs ZeffectDate )
              WITH CORRESPONDING #( keys_of_active_instances )
            RESULT DATA(active_entity)
            .

      IF active_entity IS NOT INITIAL.
        result_line-%features-%field-Bukrs =  if_abap_behv=>fc-f-read_only .
        result_line-%features-%field-ZeffectDate =  if_abap_behv=>fc-f-read_only .
      ELSE.
        result_line-%features-%field-Bukrs = if_abap_behv=>fc-f-unrestricted.
        result_line-%features-%field-ZeffectDate =  if_abap_behv=>fc-f-unrestricted.
      ENDIF.

      APPEND result_line TO result.

    ENDLOOP.
  ENDMETHOD.

  METHOD checkBurks.

    READ ENTITIES OF zi_as2_zratename IN LOCAL MODE
    ENTITY RateData
    FIELDS ( Bukrs )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_ratedata).

    IF lt_ratedata IS NOT INITIAL.
      LOOP AT lt_ratedata INTO DATA(ls_ratedata).

        SELECT SINGLE bukrs
          FROM ztbukrs
          WHERE bukrs = @ls_ratedata-Bukrs
          INTO @DATA(lv_bukrs).

        IF sy-subrc <> 0 .
          ls_ratedata-%tky-%is_draft = if_abap_behv=>mk-on.
          APPEND VALUE #( %tky = ls_ratedata-%tky ) TO failed-ratedata.
          APPEND VALUE #( %tky = ls_ratedata-%tky
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text = |The company code { ls_ratedata-Bukrs }  has not existed!| )
                                                      ) TO reported-ratedata.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD checkRateData.

    READ ENTITIES OF zi_as2_zratename IN LOCAL MODE
    ENTITY RateData
    FIELDS ( Bukrs ZeffectDate ParentID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_ratedata).

    IF lt_ratedata IS NOT INITIAL.
      DATA(lv_parrentid) = lt_ratedata[ 1 ]-ParentID .
      READ ENTITIES OF zi_as2_zratename IN LOCAL MODE
        ENTITY RateName
        FIELDS ( Zrateid )
        WITH VALUE #( ( %key-id = lv_parrentid ) )
        RESULT DATA(lt_ratename).

      IF lt_ratename IS NOT INITIAL.
        DATA(lv_zrateid) = lt_ratename[ 1 ]-Zrateid.



        LOOP AT lt_ratedata INTO DATA(ls_ratedata).
          SELECT SINGLE *
            FROM ztratedata
            WHERE bukrs = @ls_ratedata-Bukrs
              AND zrateid = @lv_zrateid
              AND zeffect_date = @ls_ratedata-ZeffectDate
            INTO @DATA(ls_ratedata2).

          IF ls_ratedata2 IS NOT INITIAL.
            ls_ratedata-%tky-%is_draft = if_abap_behv=>mk-on.
            APPEND VALUE #( %tky = ls_ratedata-%tky ) TO failed-ratedata.
            APPEND VALUE #( %tky = ls_ratedata-%tky
                            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = |The Rate Data of { ls_ratedata-Bukrs  }-{ ls_ratedata-ZeffectDate DATE = ENVIRONMENT  } has existed| )
                                                        ) TO reported-ratedata.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.


  ENDMETHOD.

ENDCLASS.

CLASS lhc_ratename DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR RateName RESULT result.
    METHODS checkrateid FOR VALIDATE ON SAVE
      IMPORTING keys FOR ratename~checkrateid.
    METHODS checkCycleZone FOR VALIDATE ON SAVE
      IMPORTING keys FOR ratename~checkCycleZone.

ENDCLASS.

CLASS lhc_ratename IMPLEMENTATION.

  METHOD get_instance_features.
    DATA result_line LIKE LINE OF result.
    DATA keys_of_active_instances TYPE TABLE FOR INSTANCE FEATURES KEY zi_as2_zratename.

    LOOP AT keys INTO DATA(key).


      CLEAR keys_of_active_instances.
      APPEND INITIAL LINE TO  keys_of_active_instances.

      keys_of_active_instances[ 1 ]-%tky = key-%tky.
      "change the %is_draft flag to read only the active instance
      keys_of_active_instances[ 1 ]-%is_draft = if_abap_behv=>mk-off.

      result_line-%tky = key-%tky.

      READ ENTITIES OF zi_as2_zratename IN LOCAL MODE
            ENTITY RateName
              FIELDS ( Zrateid )
              WITH CORRESPONDING #( keys_of_active_instances )
            RESULT DATA(active_entity)
            .

      IF active_entity IS NOT INITIAL.
        result_line-%features-%field-Zrateid =  if_abap_behv=>fc-f-read_only .
      ELSE.
        result_line-%features-%field-Zrateid = if_abap_behv=>fc-f-unrestricted.
      ENDIF.

      APPEND result_line TO result.

    ENDLOOP.
  ENDMETHOD.

  METHOD checkRateID.
    READ ENTITIES OF zi_as2_zratename IN LOCAL MODE
        ENTITY RateName
        FIELDS ( Zrateid )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_ratename).

    IF lt_ratename IS NOT INITIAL.
      DATA(ls_ratename) = lt_ratename[ 1 ].
      SELECT SINGLE zrateid
        FROM ztratename
        WHERE zrateid = @ls_ratename-Zrateid
        INTO @DATA(lv_zrateid).

      IF lv_zrateid IS NOT INITIAL.
        ls_ratename-%tky-%is_draft = if_abap_behv=>mk-on.
        APPEND VALUE #( %tky = ls_ratename-%tky ) TO failed-ratename.
        APPEND VALUE #( %tky = ls_ratename-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Rate ID has already existed. Please change!' )
                                                    ) TO reported-ratename.
      ENDIF.

    ENDIF.
  ENDMETHOD.

  METHOD checkCycleZone.

    READ ENTITIES OF zi_as2_zratename IN LOCAL MODE
      ENTITY RateName
      FIELDS ( Zcycle Zzone )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_ratename).

    IF lt_ratename IS NOT INITIAL.
      DATA(ls_ratename) = lt_ratename[ 1 ].
      IF ls_ratename-Zzone <> '1'
         AND ls_ratename-Zzone <> '0'.
        ls_ratename-%tky-%is_draft = if_abap_behv=>mk-on.
        APPEND VALUE #( %tky = ls_ratename-%tky ) TO failed-ratename.
        APPEND VALUE #( %tky = ls_ratename-%tky
             %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                           text = 'The value of Cycle can only be 0 or 1' )
                                         ) TO reported-ratename.
      ENDIF.
      IF ls_ratename-Zcycle <> '1'
         AND ls_ratename-Zzone <> '0'.
        ls_ratename-%tky-%is_draft = if_abap_behv=>mk-on.
        APPEND VALUE #( %tky = ls_ratename-%tky ) TO failed-ratename.
        APPEND VALUE #( %tky = ls_ratename-%tky
             %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                           text = 'The value of Zone can only be 0 or 1' )
                                         ) TO reported-ratename.

      ENDIF.
    ENDIF.

  ENDMETHOD.


ENDCLASS.

CLASS lsc_ratename DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.


ENDCLASS.

CLASS lsc_ratename IMPLEMENTATION.

  METHOD save_modified.
    DATA: lt_ratename TYPE STANDARD TABLE OF ztratename,
          ls_ratename TYPE ztratename,
          lt_ratedata TYPE STANDARD TABLE OF ztratedata,
          ls_ratedata TYPE ztratedata.
*  Set up unmanaged save for RateName
    IF create-ratename IS NOT INITIAL.
      CLEAR: lt_ratename.
      LOOP AT create-ratename INTO DATA(ls_create).
        CLEAR: ls_ratename.
        ls_ratename = CORRESPONDING #( ls_create ).
        ls_ratename-zzid = ls_create-id.
        ls_ratename-last_change_at = ls_create-LastChangeAt.
        ls_ratename-erdat = cl_abap_context_info=>get_system_date( ).
        IF ls_ratename-zrateid IS INITIAL.
          TRY.
              CALL METHOD cl_numberrange_runtime=>number_get
                EXPORTING
                  nr_range_nr = '01'
                  object      = 'ZNRZRATEID'
                  quantity    = 1
                IMPORTING
                  number      = DATA(lv_number).
            CATCH cx_nr_object_not_found.
            CATCH cx_number_ranges.
          ENDTRY.
          IF lv_number IS NOT INITIAL.
            ls_ratename-zrateid = |{ lv_number ALPHA = OUT  }|.
          ENDIF.
        ENDIF.
        APPEND ls_ratename TO lt_ratename.
      ENDLOOP.

      INSERT ztratename FROM TABLE @lt_ratename.
    ENDIF.

    IF update-ratename IS NOT INITIAL.
      CLEAR: lt_ratename.
      LOOP AT update-ratename INTO DATA(ls_update).
        CLEAR: ls_ratename.
        ls_ratename = CORRESPONDING #( ls_update ).
        ls_ratename-zzid = ls_update-id.
        ls_ratename-last_change_at = ls_update-LastChangeAt.
        ls_ratename-aedat = cl_abap_context_info=>get_system_date( ).
        APPEND ls_ratename TO lt_ratename.
      ENDLOOP.
      UPDATE ztratename FROM TABLE @lt_ratename.
    ENDIF.

    IF delete-ratename IS NOT INITIAL.
      CLEAR: lt_ratename.
      LOOP AT delete-ratename INTO DATA(ls_delete).
        CLEAR: ls_ratename.
        SELECT SINGLE *
            FROM ztratename
            WHERE zzid = @ls_delete-id
            INTO @ls_ratename.

        APPEND ls_ratename TO lt_ratename.
      ENDLOOP.
      DELETE ztratename FROM TABLE @lt_ratename.
    ENDIF.

*  Set up unmanaged save for RateData
    IF create-ratedata IS NOT INITIAL.
      CLEAR: lt_ratedata.
      LOOP AT create-ratedata INTO DATA(ls_create2).
        CLEAR: ls_ratedata.
        ls_ratedata = CORRESPONDING #( ls_create2 ).
        IF ls_create-Zrateid IS NOT INITIAL.
          ls_ratedata-zrateid = ls_create-Zrateid.
        ELSE.
          SELECT SINGLE zrateid
              FROM ztratename
              WHERE zzid = @ls_create2-ParentID
              INTO @DATA(lv_zrateid).
          IF sy-subrc = 0.
            ls_ratedata-zrateid = lv_zrateid.
          ENDIF.
        ENDIF.
        ls_ratedata-zzid = ls_create2-id.
        ls_ratedata-zzparentid = ls_create2-ParentID.
        ls_ratedata-zeffect_date = ls_create2-ZeffectDate.
        ls_ratedata-last_change_at = ls_create2-LastChangeAt.
        ls_ratedata-erdat = cl_abap_context_info=>get_system_date( ).
        APPEND ls_ratedata TO lt_ratedata.
      ENDLOOP.


      INSERT ztratedata FROM TABLE @lt_ratedata.
    ENDIF.

    IF update-ratedata IS NOT INITIAL.
      CLEAR: lt_ratedata.
      LOOP AT update-ratedata INTO DATA(ls_update2).
        CLEAR: ls_ratedata.
        ls_ratedata = CORRESPONDING #( ls_update2 ).
        ls_ratedata-zzid = ls_update2-id.
        ls_ratedata-zzparentid = ls_update2-ParentID.
        ls_ratedata-zeffect_date = ls_update2-ZeffectDate.
        ls_ratedata-last_change_at = ls_update2-LastChangeAt.
        ls_ratedata-aedat = cl_abap_context_info=>get_system_date( ).
        APPEND ls_ratedata TO lt_ratedata.
      ENDLOOP.
      UPDATE ztratedata FROM TABLE @lt_ratedata.
    ENDIF.

    IF delete-ratedata IS NOT INITIAL.
      CLEAR: lt_ratedata.
      LOOP AT delete-ratedata INTO DATA(ls_delete2).

        CLEAR: ls_ratedata.
        SELECT SINGLE *
            FROM ztratedata
            WHERE zzid = @ls_delete2-id
            INTO @ls_ratedata.

        IF sy-subrc = 0.
          APPEND ls_ratedata TO lt_ratedata.
        ENDIF.
      ENDLOOP.
      DELETE ztratedata FROM TABLE @lt_ratedata.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
