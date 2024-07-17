#include <ruby.h>
#include <stdio.h>
#include "libcsv.h"

void processCsv(const char *csv, const char *selectedColumns, const char *rowFilterDefinitions) {
    int state;

    ruby_init();
    rb_load_protect(rb_str_new_cstr("./script_csv.rb"), 0, &state);
    VALUE rb_csv = rb_str_new_cstr(csv);
    VALUE rb_selectedColumns = rb_str_new_cstr(selectedColumns);
    VALUE rb_rowFilterDefinitions = rb_str_new_cstr(rowFilterDefinitions);
    VALUE result = rb_funcall(rb_cObject, rb_intern("process_csv"), 3, rb_csv, rb_selectedColumns, rb_rowFilterDefinitions);
    
    const char *result_str = StringValueCStr(result);
    printf("%s\n", result_str);
    ruby_finalize();

    return;
}

void processCsvFile(const char *csvFilePath, const char *selectedColumns, const char *rowFilterDefinitions){
    VALUE rb_csv = rb_str_new_cstr(csvFilePath);
    VALUE rb_selectedColumns = rb_str_new_cstr(selectedColumns);
    VALUE rb_rowFilterDefinitions = rb_str_new_cstr(rowFilterDefinitions);
    VALUE result = rb_funcall(rb_cObject, rb_intern("process_csv_file"), 3, rb_csv, rb_selectedColumns, rb_rowFilterDefinitions);
    
    const char *result_str = StringValueCStr(result);
    printf("%s\n", result_str);
    return;
}