initialize <- function(){
  if(!file.exists(fs::path(bblib(),".git"))){
    system("(cd $bblib; git init)")
  }
  if(!file.exists(fs::path(bblib(),".dvc"))){
    system("(cd $bblib; dvc init)")
  }
}