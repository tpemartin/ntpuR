#' Setup Github username and email
#'
#' @return None
#' @export
#'
#' @examples
setup_github_username_email = function (){

  username <- rstudioapi::showPrompt("Github setup", "What is your Github username?")
  email <- rstudioapi::showPrompt("Github setup", "What is your GitHub email? ")

  usethis::edit_r_environ("project") -> renvpath

  # Add the following lines to the .Renviron file
  # github_username, github_email, renvpath

  paste0(c(
    paste0("github_username=", username),
    paste0("github_email=",email),
    paste0("renvpath=",renvpath)),
    sep="\n") |>
    writeLines(renvpath)

  rstudioapi::restartSession()

}
#' Setup Github personal access token after setting up username and email
#'
#' @return None
#' @export
#'
#' @examples
setup_github_personal_access_token = function(){

  if( Sys.getenv("github_username")=="") stop("Please run setup_github_username_email() first")

  usethis::create_github_token()

  github_token <- rstudioapi::showPrompt("Github setup", "Perssonal Assess Token")

  paste0(c(
    paste0("github_username=", Sys.getenv("github_username")),
    paste0("github_email=",Sys.getenv("github_email")),
    paste0("renvpath=",Sys.getenv("renvpath")),
    paste0("GITHUB_PAT=",github_token)),
    sep="\n") |>
    writeLines(Sys.getenv("renvpath"))

  warning("After session restart, please run update_github_credentials() to finish the setup.")

  rstudioapi::restartSession()

}
#' Update Github credentials
#' Run this after setting up username, email and personal access token. Or
#' when github push stops working in RStudio.
#'
#' @return None
#' @export
#'
#' @examples
update_github_credentials = function(){
  usethis::use_git_config(user.name = Sys.getenv("github_username"), user.email =Sys.getenv("github_email"))

  if(Sys.getenv("GITHUB_PAT")=="") stop("Please run setup_github_personal_access_token() first")

  cat(
    "Your personal access token is below\n",
    "use it to finish the setup:\n",
    Sys.getenv("GITHUB_PAT"))

  gitcreds::gitcreds_set()
}
