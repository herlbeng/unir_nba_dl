/c/Users/Z408284/bin:/mingw64/bin:/usr/local/bin:/usr/bin:/bin:/mingw64/bin:/usr/bin:/c/Users/Z408284/bin:/c/Program Files (x86)/Common Files/Oracle/Java/javapath:/c/Windows/system32:/c/Windows:/c/Windows/System32/Wbem:/c/Windows/System32/WindowsPowerShell/v1.0:/c/Windows/System32/OpenSSH:/c/Program Files/dotnet:/c/Program Files/Microsoft VS Code/bin:/cmd:/c/Users/Z408284/AppData/Local/Microsoft/WindowsApps:/usr/bin/vendor_perl:/usr/bin/core_perl


El proceso de estandarización en el código tiene 2 actividades:

1) Estandarización de código Terraform: Objetos de configuracion, variables y etiquetas.
2) Estandarización de nombres para recursos y servicios de AWS.

1

a. Todos los objetos de configuración para tipos de recursos deben utilizar underscore en su denominación (sin cambios).
archivo lambda_iam.tf (linea 2)
por consecuencia archivo lambda_invoke.tf (linea)

b. Evitar redundancias entre el nombramiento de la clase (tipo) y el nombre del objeto de configuracion.

c. estructura y nombres de archivo
Archivo provider (ok)
Archivo main por folder ()



d. variables

2


El alcance del proceso ocupa solamente archivos .tf



#Role policy attachment for exec roles [data science, data engineering, ml engineering]
resource "aws_iam_role_policy_attachment" "sagemaker_exec_role" {
  for_each           = var.user_profile_names
  role       = aws_iam_role.sagemaker_exec_role[each.key].name
  policy_arn = aws_iam_role.sagemaker_exec_role[each.key].policy.arn  #ATENCION
}