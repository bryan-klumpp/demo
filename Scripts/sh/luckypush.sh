  git status
  echo
  echo "Press Ctrl+C within 5 seconds to cancel push..."
  { sleep 5 &&
   cd /c/b/code/demo &&
  (git add *) &&
  git commit -m "I will not dignify this code with a comment" &&
  git push && echo 'pushed!'
} || {
  echo "Push cancelled or failed." #not sure why this won't print on cancel?
}

