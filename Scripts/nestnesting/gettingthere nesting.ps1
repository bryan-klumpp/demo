start-process -filepath powershell -argumentlist "-noexit -command &{echo window1; start-process powershell -argumentlist '&{ -noexit; echo window2; notepad; pause}' ; pause }"

function gnp() { return ("start-process -filepath powershell -argumentlist '-noexit -command &{"+$args[0]+"}'")  }
function gnp2() { $q="'"; return ('start-process -filepath powershell -argumentlist '+$q+'-noexit -command `&{'+$args[0]+'}'+$q)  }
function gnpr() { $q="'"; return ("start-process -filepath powershell -argumentlist '-noexit -command &{"+$args[0]+"}' -verb RunAs")  }
function gnpr2() { $q="'"; return ('start-process -filepath powershell -argumentlist '+$q+'-noexit -command &{'+$args[0]+'}'+$q+' -verb RunAs')  }

