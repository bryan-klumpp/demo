export default {
  spec_dir: "spec",
  spec_files: [
    "../sampleSpec.js",
  ],
  spec_files_default: [
    "**/*[sS]pec.?(m)js"
  ],
  helpers: [
    "helpers/**/*.?(m)js"
  ],
  env: {
    stopSpecOnExpectationFailure: false,
    random: true,
    forbidDuplicateNames: true
  }
}
