CLASS zcl_abapgit_object_chkc DEFINITION PUBLIC
  INHERITING FROM zcl_abapgit_object_common_aff
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS zif_abapgit_object~changed_by REDEFINITION.
    METHODS zif_abapgit_object~deserialize REDEFINITION.
    METHODS zif_abapgit_object~serialize REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_abapgit_object_chkc IMPLEMENTATION.


  METHOD zif_abapgit_object~changed_by.

    DATA: lr_data        TYPE REF TO data,
          lo_chkc_db_api TYPE REF TO object,
          lv_name        TYPE c LENGTH 120,
          lx_error       TYPE REF TO cx_root.

    FIELD-SYMBOLS: <ls_chkc_header> TYPE any,
                   <ls_chkc_user>   TYPE any.

    IF ms_item-obj_type <> 'CHKC'.
      RETURN.
    ENDIF.

    TRY.
        CREATE OBJECT lo_chkc_db_api TYPE ('CL_CHKC_DB_API').
        CREATE DATA lr_data TYPE ('CL_CHKC_DB_API=>TY_HEADER').
        ASSIGN lr_data->* TO <ls_chkc_header>.

        lv_name = ms_item-obj_name.

        CALL METHOD lo_chkc_db_api->('GET_HEADER')
          EXPORTING
            name    = lv_name
            version = 'I'
          RECEIVING
            header  = <ls_chkc_header>.

        IF <ls_chkc_header> IS INITIAL.
          CALL METHOD lo_chkc_db_api->('GET_HEADER')
            EXPORTING
              name    = lv_name
              version = 'A'
            RECEIVING
              header  = <ls_chkc_header>.
        ENDIF.

        ASSIGN COMPONENT 'CHANGED_BY' OF STRUCTURE <ls_chkc_header> TO <ls_chkc_user>.
        rv_user = <ls_chkc_user>.

      CATCH cx_root INTO lx_error.
        zcx_abapgit_exception=>raise_with_text( lx_error ).
    ENDTRY.

  ENDMETHOD.


  METHOD zif_abapgit_object~deserialize.

    IF ms_item-obj_type <> 'CHKC'.
      RETURN.
    ENDIF.

    super->zif_abapgit_object~deserialize(
        iv_transport = iv_transport
        iv_package = iv_package
        io_xml     = io_xml
        iv_step    = iv_step
        ii_log     = ii_log   ).

  ENDMETHOD.


  METHOD zif_abapgit_object~serialize.

    IF ms_item-obj_type <> 'CHKC'.
      RETURN.
    ENDIF.

    super->zif_abapgit_object~serialize( io_xml = io_xml ).

  ENDMETHOD.
ENDCLASS.
