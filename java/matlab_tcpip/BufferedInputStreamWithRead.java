/**BufferedInputStream class with Matlab-friendly read method.
 *
 * javac BufferedInputStreamWithRead.java;
 */
package matlab_tcpip;

public class BufferedInputStreamWithRead extends java.io.BufferedInputStream {
  public BufferedInputStreamWithRead(java.io.InputStream in) {
    super(in);
  }

  public BufferedInputStreamWithRead(java.io.InputStream in, int size) {
    super(in, size);
  }

  /**
   * Read the specified length of bytes from the stream.
   *
   * @param  len  Length of bytes to read.
   * @return bytes in an array.
   *
   */
  public byte[] read(int len) throws java.io.IOException {
    byte[] buffer = new byte[len];
    int readBytes = read(buffer, 0, len);
    if (readBytes > 0 && readBytes < len) {
      byte[] newBuffer = new byte[readBytes];
      System.arraycopy(buffer, 0, newBuffer, 0, readBytes);
      buffer = newBuffer;
    }
    else if (readBytes <= 0) {
      buffer = new byte[0];
    }
    return buffer;
  }
}
