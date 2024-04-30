{
  buildLua,
  fetchurl,
  mpv,
  ffmpeg,
}:
buildLua rec {
  pname = "sub-cut";
  version = "2018-11-02";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/kelciour/mpv-scripts/master/sub-cut.lua";
    hash = "sha256-syn2gmzPeUqFTqxXT3Nl2JdeGROmejvcOadts7ltN5M=";
  };
  unpackPhase = "cp ${src} $(stripHash $src)";

  postPatch = ''
    substituteInPlace ${scriptPath} \
      --replace 'mpv_path = [[mpv]]' 'mpv_path = [[${mpv}/bin/mpv]]' \
      --replace 'ffmpeg_path = [[ffmpeg]]' 'ffmpeg_path = [[${ffmpeg}/bin/ffmpeg]]'
  '';

  scriptPath = "sub-cut.lua";

  meta = {
    description = "extract a part of the video as audio or video (with or without subtitles)";
    homepage = "https://github.com/kelciour/mpv-scripts";
    longDescription = ''
      Usage:

         w - set start timestamp
         e - set end timestamp

         ctrl+z - cut audio fragment
         ctrl+x - cut video fragment (with softsub subtitles)
         ctrl+c - cut video fragment with hardsub subtitles

         ctrl+w - replay from the start timestamp
         ctrl+e - replay the last n seconds until the end timestamp
         ctrl+r - reset timestamps
    ''; # taken from lua file
  };
}
