{ bundlerApp }:

bundlerApp {
  pname = "oneaws";
  gemdir = ./.;
  exes = [ "oneaws" ];
  postBuild = ''
    sed -i '2i ENV["GEM_PATH"] = ""' $out/bin/oneaws
  '';

  meta = {
    description = "CLI tool for AWS authentication via OneLogin";
    homepage = "https://github.com/AnyBridge/oneaws";
    mainProgram = "oneaws";
  };
}
