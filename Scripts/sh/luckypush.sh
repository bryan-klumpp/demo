  git status
  echo
  echo "Press Ctrl+C within 5 seconds to cancel push..."
  { sleep 5 &&
  git add * &&
  git commit -m "I will not dignify this code with a comment" &&
  git push
} || {
  echo "Push cancelled or failed." #not sure why this won't print on cancel?
}

