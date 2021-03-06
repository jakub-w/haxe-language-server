package haxeLanguageServer.helper;

class FsPathHelper {
	static final upperCaseDriveRe = ~/^(\/)?([A-Z]:)/;

	/** ported from VSCode sources **/
	public static function toUri(path:FsPath):DocumentUri {
		var path = path.toString();
		path = path.replace("\\", "/");
		if (path.fastCodeAt(0) != "/".code)
			path = "/" + path;

		var parts = ["file://"];

		if (upperCaseDriveRe.match(path))
			path = upperCaseDriveRe.matched(1) + upperCaseDriveRe.matched(2).toLowerCase() + upperCaseDriveRe.matchedRight();

		var lastIdx = 0;
		while (true) {
			var idx = path.indexOf("/", lastIdx);
			if (idx == -1) {
				parts.push(UrlEncoder.urlEncode2(path.substring(lastIdx)));
				break;
			}
			parts.push(UrlEncoder.urlEncode2(path.substring(lastIdx, idx)));
			parts.push("/");
			lastIdx = idx + 1;
		}
		return new DocumentUri(parts.join(""));
	}
}

private class UrlEncoder {
	public static function urlEncode2(s:String):String {
		return ~/[!'()*]/g.map(s.urlEncode(), function(re) {
			return "%" + re.matched(0).fastCodeAt(0).hex();
		});
	}
}
