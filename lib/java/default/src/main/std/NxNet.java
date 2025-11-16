package main.std;

import java.net.ServerSocket;
import java.net.UnknownHostException;
import java.net.InetAddress;

public class NxNet
{
	public static InetAddress[] drill(String fqdn) throws UnknownHostException {
		return InetAddress.getAllByName(fqdn);
	}

        public static int port(int p) {
                boolean a = false;
                p = NxBits.modNext(p, 65536);
                int i = p;
                while (! a && p < 65536) {
                        try (ServerSocket s = new ServerSocket(p)) {
                                s.setReuseAddress(true);
                                a = true;
                        } catch (Exception e) {
                                p++;
                        }
                }
                if (! a)
                        throw new IllegalArgumentException("All 65,535 ports starting at " + i + " are spoken for. The network is now a sold-out stadium.");
                return a ? p : -1;
        }
}

