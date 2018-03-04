@RestResource(urlMapping='/cifrar/*')
global class PruebaCripto {

	private static final String	ENCODEMODE	= 'UTF-8';
	private static final String	CIPHER_TRANSFORM_ALGORITHM = 'AES/CBC/PKCS5Padding';
	private static final String	ALGORITHM_ENCRYPT_METHOD 	= 'AES';
	private static String kyCipher = 'PRUEBADELLAVEPARAELCIFRADODEBAZD';
	private static String ivParameter = '1234567890123456';

	@HttpPost
	global static String cifrar(String msg, String key,Boolean emcriptar)
	{
		Blob iv = Blob.valueOf(ivParameter);
		Blob keyc = EncodingUtil.base64Decode(key);
		String encodedCipherText='';
		// String clearText = 'Esta es una prueba con afore de encripcion con java y salesforce';
		if (emcriptar)
		{
			Blob data = Blob.valueOf(msg);
			Blob cipherText = Crypto.encrypt('AES256', keyc, iv, data);
			//Crypto.encryptWithManagedIV('AES256', keyc, Blob.valueOf(msg));
			encodedCipherText = EncodingUtil.base64Encode(cipherText);
			System.debug(encodedCipherText);
		}
		else
		{
			Blob data = EncodingUtil.base64Decode(msg);
			Blob decryptedData = Crypto.decrypt('AES256', keyc, iv, data);
			//Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, data);
			encodedCipherText = decryptedData.toString();
		}
		return encodedCipherText;
	}

	public PruebaCripto()
	{
		String cadena = 'Cadena en claro';
		// String encriptado = encryptString(cadena);
		// System.out.println(encriptado);
		// System.out.println(decryptString(encriptado));
	}
	public string comienzo(String msg)
	{
		return '';
	}

	public static String encryptString(String text)
	{
		return '';
	}

	// public static String encryptSafeUrl(String message)
	// {
	// 	// kyCipher = (kyCipher.length()>32?kyCipher.substring(0,32):kyCipher);
	// 	// Blob key = EncodingUtil.base64Decode(kyCipher);
	// 	// Blob cipherText = Crypto.encryptWithManagedIV(ALGORITHM_ENCRYPT_METHOD, key, Blob.valueOf(clearText));
	// 	// // String encodedCipherText = EncodingUtil.base64Encode(cipherText);
	// 	// return '';
	// }
}