; extends

; highlight raw strings as sql when they're prefixed by an SQL func call
; or when they contain simple sql keywords.
(call_expression
  (selector_expression
	field: (field_identifier) @_field (#match? @_field "(Query(Row)?|Exec)Context?"))
  (argument_list
	(raw_string_literal) @sql (#offset! @sql 0 1 0 -1))
)

; database/sql query, but there's an fmt.Sprintf()
(call_expression
  (selector_expression
	field: (field_identifier) @_field (#match? @_field "(Query(Row)?|Exec)Context?"))
  (argument_list
	(call_expression
	  (argument_list
		(raw_string_literal) @sql (#offset! @sql 0 1 0 -1))))
)

; for the occasional case where queries are concatenated, not perfect
((raw_string_literal) @sql 
      (#contains? @sql "SELECT" "INSERT" "UPDATE" "DELETE" "CREATE" "ALTER") 
      (#offset! @sql 0 1 0 -1))

; get random html
((raw_string_literal) @html
	(#contains? @html "<!doctype html>" "</")
	(#offset! @html 0 1 0 -1))
