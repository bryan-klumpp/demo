 The demo repository is my "working portfolio". It contains Eclipse projects in various stages of development; when they reach a sufficient level of polish and documentation they will be moved to a "production" repository.

The main purpose at the moment is to demonstrate my coding knowledge, style, and progress to prospective employers as I learn some new frameworks and practice design patterns.

**Projects**:

**AutoHotkey**: I find AutoHotkey to be quite useful for automating various development tasks. Eclipse helps with version management, but for editing the scripts I prefer Notepad++ (try AutoIt syntax highlighting).

**BJShell**: This project showcases my grasp of core Java and design patterns. While Swing is less popular these days for new rich client development, I still find it very useful for hacking up custom developer utilities. SwingShell is a shell in the spirit of PowerShell and bash; while it is pretty basic at the moment, it does integrate regular expressions in a unique way and is extensible with custom Java commands. For the basics just run DemoSwingShellLauncher (note that JRE 1.8 has problems with font smoothing, try newer versions like JDK15). While fully functional, it does needs more documentation which is my next step before moving it to the "production" repository.

**JDemoWeb**: A "Hello World" type project for various Spring features. It was difficult to find wizards or online sample templates to create the Spring plumbing for the latest (as of June 2021) versions of Eclipse and Spring with JPA (multiple datasource capability) and Thymeleaf, so this is the template that I created. Needs some cleanup, but works as a reference. Note that it also includes an example of including another Eclipse project as a library. See documentation/server_config_and_test_setup.html

**JDemoWebLegacy**: A "Hello World" type project for various legacy Spring features. I was struggling to find wizards or online sample templates to create the Spring plumbing for the latest (as of June 2021) version of Eclipse with an older version of Spring with JPA and Spring MVC, so this is the template that I created. Needs some cleanup, but works as a reference. See documentation/server_config_and_test_setup.html  CAUTION: some of the Maven-referenced libraries are old enough to be flagged for security vulnerabilities, so I don't recommending using this except as absolutely necessary to assist in keeping legacy apps (which should be upgraded ASAP) functioning.

**JDemoWebLib**: A sample web library project, see JDemoWeb


Bryan Klumpp<br>
Peoria, IL 
