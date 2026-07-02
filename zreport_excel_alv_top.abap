*&---------------------------------------------------------------------*
*& Include ZREPORT_EXCEL_ALV_TOP
*&---------------------------------------------------------------------*
*& Datendefinitionen und globale Variablen
*&---------------------------------------------------------------------*

*----------- Tabellen & Strukturen -----------
TYPES: BEGIN OF ty_data,
         matnr     TYPE mara-matnr,      " Materialnummer
         maktx     TYPE makt-maktx,      " Materialname
         meins     TYPE mara-meins,      " Basismengeneinheit
         netpr     TYPE konp-netpr,      " Netto-Preis
         status    TYPE char10,          " Status (OK/FEHLER)
         message   TYPE char255,         " Fehlermeldung
       END OF ty_data.

TYPES: BEGIN OF ty_excel_raw,
         col1      TYPE string,
         col2      TYPE string,
         col3      TYPE string,
         col4      TYPE string,
       END OF ty_excel_raw.

*----------- Globale Variablen -----------
DATA: gt_data         TYPE TABLE OF ty_data,
      gt_excel_raw    TYPE TABLE OF ty_excel_raw,
      gs_data         TYPE ty_data,
      gs_excel_raw    TYPE ty_excel_raw,
      gv_filename     TYPE string,
      gv_path         TYPE string,
      gv_fullpath     TYPE string,
      g_alv_grid      TYPE REF TO cl_gui_alv_grid,
      g_custom_container TYPE REF TO cl_gui_custom_container.

*----------- ALV Layout & Spalten -----------
DATA: gs_layout       TYPE lvc_s_layo,
      gt_fieldcat     TYPE lvc_t_fcat,
      gs_fieldcat     TYPE lvc_s_fcat.
