project('com.github.aharotias2.ferconn', 'vala', 'c', version: '1.0.0')

library(
  'libferconn',
  'src/ferconn_abstract_dao.vala',
  'src/ferconn_column_set.vala',
  'src/ferconn_gee_utils.vala',
  'src/ferconn_sealed_map.vala',
  'src/ferconn_sql_utils.vala',
  'src/ferconn_value_utils.vala',
  dependencies: [
    dependency('glib-2.0'),
    dependency('libgda-5.0'),
    dependency('gee-0.8'),
    dependency('libxml-2.0')
  ],
  install: true
)

column_set_tests = executable(
  'ferconn_column_set_tests',
  'tests/ferconn_column_set_tests.vala',
  'src/ferconn_column_set.vala',
  'src/ferconn_sealed_map.vala',
  dependencies: [
    dependency('glib-2.0'),
    dependency('libgda-5.0'),
    dependency('gee-0.8'),
    dependency('libxml-2.0')
  ]
)

abstract_dao_tests = executable(
  'ferconn_abstract_dao_tests',
  'tests/ferconn_abstract_dao_tests.vala',
  'src/ferconn_abstract_dao.vala',
  'src/ferconn_column_set.vala',
  'src/ferconn_sealed_map.vala',
  'src/ferconn_sql_utils.vala',
  'src/ferconn_gee_utils.vala',
  'src/ferconn_value_utils.vala',
  dependencies: [
    dependency('glib-2.0'),
    dependency('libgda-5.0'),
    dependency('gee-0.8'),
    dependency('libxml-2.0')
  ]
)

test('ferconn_column_set_tests', column_set_tests, args: [])
test('ferconn_abstract_dao_tests', abstract_dao_tests, args: [])
