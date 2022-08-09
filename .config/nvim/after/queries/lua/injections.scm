((assignment_statement
  (variable_list name: (_) @_conkytext_identifier)
  (expression_list (string content: _ @bash)))

(#eq? @_conkytext_identifier "conky.text"))
