  git status
  echo "Press Ctrl+C within 5 seconds to cancel push..."
  sleep 5 && {
  git add * &&
  git commit -m "Sorry, I'm being lazy" &&
  git push
}
