package com.okmindmap.api.shorturl;

public final class OkmmSite {
	public static String encodeMapId(final int mapid) {
		String hash = "QWEklzxcvRTYU45678IOPASDFGHasdfgJKLZXqwertyCVBNMuiophjbnm12390";
		int i1 = mapid % 62;
		int i2 = (mapid - i1) / 62 / 62 / 62;
		int i3 = (mapid - i1 - i2 * 62 * 62 * 62) / 62 / 62;
		int i4 = (mapid - i1 - i2 * 62 * 62 * 62 - i3 * 62 * 62) / 62;
		return String.valueOf(hash.charAt(i1)) + String.valueOf(hash.charAt(i2)) + String.valueOf(hash.charAt(i3))
				+ String.valueOf(hash.charAt(i4));
	}

	public static int decodeMapId(final String code) {
		String hash = "QWEklzxcvRTYU45678IOPASDFGHasdfgJKLZXqwertyCVBNMuiophjbnm12390";
		int i1 = hash.indexOf(String.valueOf(code.charAt(0)));
		int i2 = hash.indexOf(String.valueOf(code.charAt(1)));
		int i3 = hash.indexOf(String.valueOf(code.charAt(2)));
		int i4 = hash.indexOf(String.valueOf(code.charAt(3)));

		return i1 + i2 * 62 * 62 * 62 + i3 * 62 * 62 + i4 * 62;
	}
	
	public static String shorten(final int mapid) {
		return "okm.vn/s/" + OkmmSite.encodeMapId(mapid);
	}

//	public static void main(String[] args) {
//		String code = OkmmSite.encodeMapId(10540001);
//		System.out.println(OkmmSite.decodeMapId(code));
//		System.out.println(code);
//	}
}
