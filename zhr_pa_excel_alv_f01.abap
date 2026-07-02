*&---------------------------------------------------------------------*
*& Include ZHR_PA_EXCEL_ALV_F01
*&---------------------------------------------------------------------*
*& Performroutinen für Excel-Import
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& FORM select_file
*&---------------------------------------------------------------------*
FORM select_file.
  DATA: l_rc   TYPE i,
        l_path TYPE string,
        l_file TYPE string.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog(
    EXPORTING
      default_filename      = '*.xlsx'
      default_extension    = 'xlsx'
      window_title         = 'Excel Datei auswählen'
      multiselection       = abap_false
    IMPORTING
      filename             = l_file
      path                 = l_path
      fullpath             = gv_fullpath
    CHANGING
      file_table           = gt_data
    EXCEPTIONS
      cfilter_activate_failed = 1
      cfilter_deactivate_failed = 2
      error_no_gui         = 3
      not_supported_by_gui = 4
      invalid_default_filename = 5
      others               = 6
  ).

  IF sy-subrc EQ 0 AND l_file IS NOT INITIAL.
    gv_filename = l_file.
    gv_path = l_path.
    p_file = gv_fullpath.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& FORM read_excel
*&---------------------------------------------------------------------*
FORM read_excel.
  DATA: l_file_table  TYPE filetable,
        l_rc          TYPE i,
        l_subrc       TYPE i,
        l_file_size   TYPE i,
        l_xstring     TYPE xstring,
        l_data_tab    TYPE TABLE OF alsmex_tabline,
        ls_tabline    TYPE alsmex_tabline,
        l_row         TYPE i,
        l_col         TYPE i.

  CLEAR: gt_data, gt_excel_raw.

  " Datei vom Frontend lesen - Alternative: ABAP2XLSX oder OLE
  PERFORM read_excel_ole.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM read_excel_ole
*&---------------------------------------------------------------------*
FORM read_excel_ole.
  DATA: l_excel       TYPE ole2_object,
        l_workbook    TYPE ole2_object,
        l_worksheet   TYPE ole2_object,
        l_range       TYPE ole2_object,
        l_cell        TYPE ole2_object,
        l_row         TYPE i,
        l_col         TYPE i,
        l_value       TYPE string,
        l_last_row    TYPE i,
        l_last_col    TYPE i.

  CLEAR gt_excel_raw.

  TRY.
      " Excel-Anwendung erstellen
      CREATE OBJECT l_excel 'Excel.Application'.
      l_excel->invoke(
        METHOD 'Open'
        EXPORTING #1 = gv_fullpath
      ).

      " Workbook und Worksheet referenzieren
      l_workbook = l_excel->invoke(
        METHOD 'ActiveWorkbook'
      ).
      l_worksheet = l_workbook->invoke(
        METHOD 'ActiveSheet'
      ).

      " Letzte belegte Zelle ermitteln
      l_range = l_worksheet->invoke(
        METHOD 'UsedRange'
      ).
      l_last_row = l_range->invoke(
        QUERY 'Rows.Count'
      ).
      l_last_col = l_range->invoke(
        QUERY 'Columns.Count'
      ).

      " Daten auslesen (ab Zeile 2, da Zeile 1 = Header)
      DO l_last_row - 1 TIMES.
        l_row = sy-index + 1.
        CLEAR gs_excel_raw.

        DO l_last_col TIMES.
          l_col = sy-index.
          l_cell = l_worksheet->invoke(
            METHOD 'Cells'
            EXPORTING #1 = l_row #2 = l_col
          ).
          l_value = l_cell->invoke(
            QUERY 'Value'
          ).

          CASE l_col.
            WHEN 1.
              gs_excel_raw-col1 = l_value.
            WHEN 2.
              gs_excel_raw-col2 = l_value.
            WHEN 3.
              gs_excel_raw-col3 = l_value.
            WHEN 4.
              gs_excel_raw-col4 = l_value.
          ENDCASE.
        ENDDO.

        APPEND gs_excel_raw TO gt_excel_raw.
      ENDDO.

      " Excel schließen
      l_excel->invoke(
        METHOD 'Quit'
      ).

      FREE OBJECT l_cell.
      FREE OBJECT l_range.
      FREE OBJECT l_worksheet.
      FREE OBJECT l_workbook.
      FREE OBJECT l_excel.

    CATCH cx_ole_error INTO DATA(ex).
      MESSAGE e000(00) WITH 'Fehler beim Excel-Lesen: ' ex->get_text( ).
  ENDTRY.

ENDFORM.
