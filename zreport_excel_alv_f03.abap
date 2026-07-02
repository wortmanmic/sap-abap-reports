*&---------------------------------------------------------------------*
*& Include ZREPORT_EXCEL_ALV_F03
*&---------------------------------------------------------------------*
*& Performroutinen für ALV-Anzeige und Feldkatalog
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& FORM display_alv
*&---------------------------------------------------------------------*
FORM display_alv.
  PERFORM build_fieldcatalog.
  PERFORM build_layout.
  PERFORM create_alv_grid.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM build_fieldcatalog
*&---------------------------------------------------------------------*
FORM build_fieldcatalog.
  CLEAR gt_fieldcat.

  " Materialnummer
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'MATNR'.
  gs_fieldcat-coltext     = 'Material'.
  gs_fieldcat-outputlen   = 18.
  gs_fieldcat-edit        = abap_true.
  APPEND gs_fieldcat TO gt_fieldcat.

  " Materialname
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'MAKTX'.
  gs_fieldcat-coltext     = 'Materialname'.
  gs_fieldcat-outputlen   = 40.
  gs_fieldcat-edit        = abap_true.
  APPEND gs_fieldcat TO gt_fieldcat.

  " Mengeneinheit
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'MEINS'.
  gs_fieldcat-coltext     = 'Mengeneinheit'.
  gs_fieldcat-outputlen   = 3.
  gs_fieldcat-edit        = abap_true.
  APPEND gs_fieldcat TO gt_fieldcat.

  " Netto-Preis
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'NETPR'.
  gs_fieldcat-coltext     = 'Netto-Preis'.
  gs_fieldcat-outputlen   = 15.
  gs_fieldcat-decimals    = 2.
  gs_fieldcat-edit        = abap_true.
  APPEND gs_fieldcat TO gt_fieldcat.

  " Status
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'STATUS'.
  gs_fieldcat-coltext     = 'Status'.
  gs_fieldcat-outputlen   = 10.
  gs_fieldcat-edit        = abap_false.
  APPEND gs_fieldcat TO gt_fieldcat.

  " Meldung
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'MESSAGE'.
  gs_fieldcat-coltext     = 'Meldung'.
  gs_fieldcat-outputlen   = 60.
  gs_fieldcat-edit        = abap_false.
  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM build_layout
*&---------------------------------------------------------------------*
FORM build_layout.
  CLEAR gs_layout.
  gs_layout-zebra       = abap_true.
  gs_layout-sel_mode    = 'C'.            " Spaltenauswahl
  gs_layout-cwidth_opt  = abap_true.
  gs_layout-grid_title  = 'Excel-Daten Übersicht'.
  gs_layout-smalltitle  = abap_false.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM create_alv_grid
*&---------------------------------------------------------------------*
FORM create_alv_grid.
  DATA: l_container   TYPE REF TO cl_gui_custom_container,
        l_grid        TYPE REF TO cl_gui_alv_grid,
        l_toolbar     TYPE ui_functions.

  IF g_custom_container IS INITIAL.
    " Container erstellen
    CREATE OBJECT g_custom_container
      EXPORTING
        container_name = 'ALV_CONTAINER'.

    " ALV Grid erstellen
    CREATE OBJECT g_alv_grid
      EXPORTING
        i_parent          = g_custom_container
        i_appl_events     = abap_true
        i_toolbar_height  = 25.

    " Event Handler registrieren
    SET HANDLER handle_button_click FOR g_alv_grid.

    " Daten anzeigen
    CALL METHOD g_alv_grid->set_table_for_first_time
      EXPORTING
        i_buffer_active      = abap_false
        is_layout            = gs_layout
        it_fieldcatalog      = gt_fieldcat
      CHANGING
        it_outtab            = gt_data
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                = 2
        too_many_lines               = 3
        others                       = 4.

    IF sy-subrc NE 0.
      MESSAGE e000(00) WITH 'Fehler beim ALV-Anzeigen'.
    ENDIF.

    " Buttons hinzufügen
    PERFORM add_buttons.

  ELSE.
    " Daten aktualisieren
    CALL METHOD g_alv_grid->refresh_table_display
      EXPORTING
        is_stable      = abap_true
        i_soft_refresh = abap_true
      EXCEPTIONS
        finished       = 1
        others         = 2.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM add_buttons
*&---------------------------------------------------------------------*
FORM add_buttons.
  DATA: lt_toolbar TYPE ui_functions.

  CALL METHOD g_alv_grid->get_toolbar_mode(
    IMPORTING e_toolbar_mode = lt_toolbar ).

  " Bearbeiten Button
  APPEND 'EDIT_ROW' TO lt_toolbar.
  APPEND INITIAL LINE TO lt_toolbar.

  " Löschen Button
  APPEND 'DELETE_ROW' TO lt_toolbar.
  APPEND INITIAL LINE TO lt_toolbar.

  CALL METHOD g_alv_grid->set_toolbar_mode(
    EXPORTING e_toolbar_mode = lt_toolbar ).

ENDFORM.
