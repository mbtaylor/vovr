
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.astrogrid.samp.Message;
import org.astrogrid.samp.Metadata;
import org.astrogrid.samp.Response;
import org.astrogrid.samp.Subscriptions;
import org.astrogrid.samp.client.AbstractMessageHandler;
import org.astrogrid.samp.client.ClientProfile;
import org.astrogrid.samp.client.DefaultClientProfile;
import org.astrogrid.samp.client.HubConnection;
import org.astrogrid.samp.client.HubConnector;
import org.astrogrid.samp.httpd.UtilServer;

/**
 * Basic SAMP client to receive a table.
 */
public class TableClient {

    private static final String ICON_NAME = "/img/goggles2.png";
    private static final Logger logger_ = Logger.getLogger( "" );

    public TableClient( ClientProfile profile, int autoSec ) {

        HubConnector connector = new HubConnector( profile );

        Metadata meta = new Metadata();
        meta.setName( "VOVR" );
        try {
            meta.setIconUrl( UtilServer.getInstance()
                            .exportResource( ICON_NAME )
                            .toString() );
        }
        catch ( IOException e ) {
            logger_.log( Level.WARNING, "No icon: " + ICON_NAME, e );
        }
        connector.declareMetadata( meta );

        final Subscriptions subs = new Subscriptions();
        subs.addMType( "table.load.votable" );

        connector.addMessageHandler(
                new AbstractMessageHandler( "table.load.votable" ) {
            public Map processCall( HubConnection connection, String senderId,
                                    Message msg ) throws MalformedURLException {
                assert "table.load.votable".equals( msg.getMType() );
                String url = (String) msg.getRequiredParam( "url" );
                String name = (String) msg.getParam( "name" );
                String tableId = (String) msg.getParam( "table-id" );
                tableLoaded( new URL( url ) );
                return Response.createSuccessResponse( Response.EMPTY );
            }
        } );

        connector.declareSubscriptions( connector.computeSubscriptions() );
        connector.setActive( true );
        connector.setAutoconnect( autoSec );
    }

    public void tableLoaded( URL tableUrl ) {
        System.out.println( "Load table at: " + tableUrl );
    }

    public static int runMain( String[] args ) {
        ClientProfile profile = DefaultClientProfile.getProfile();
        new TableClient( profile, 5 );

        // Wait indefinitely.
        Object lock = new String( "Forever" );
        synchronized( lock ) {
            try {
                lock.wait();
            }
            catch ( InterruptedException e ) {
                Thread.currentThread().interrupt();
            }
        }
        return 0;
    }

    public static void main( String[] args ) {
        int status = runMain( args );
        if ( status != 0 ) {
            System.exit( status );
        }
    }
}
