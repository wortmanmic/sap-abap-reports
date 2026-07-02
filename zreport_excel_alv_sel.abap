*&---------------------------------------------------------------------*
*& Include ZREPORT_EXCEL_ALV_SEL
*&---------------------------------------------------------------------*
*& Selection Screen Definition
*&---------------------------------------------------------------------*

*----------- Selection Screen -----------
SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_file TYPE string LOWER CASE.
SELECTION-SCREEN END OF BLOCK blk1.

*&---------------------------------------------------------------------*
*& AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM select_file.
