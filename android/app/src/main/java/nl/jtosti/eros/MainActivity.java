package nl.jtosti.eros;

import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.pdf.PdfDocument;
import android.os.Build;
import android.os.Bundle;
import android.os.CancellationSignal;
import android.os.ParcelFileDescriptor;
import android.print.PageRange;
import android.print.PrintAttributes;
import android.print.PrintDocumentAdapter;
import android.print.PrintDocumentInfo;
import android.print.PrintJob;
import android.print.PrintManager;
import android.print.pdf.PrintedPdfDocument;
import android.support.annotation.RequiresApi;
import android.util.Log;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String PRINT_CHANNEL = "eros.jtosti.nl/print";
    private static final String TAG = "Main activity";
    private WebView mWebView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), PRINT_CHANNEL).setMethodCallHandler(
                new PrintPlugin()
        );
    }

    public class PrintPlugin implements MethodChannel.MethodCallHandler {

        @Override
        public void onMethodCall(MethodCall call, final MethodChannel.Result result) {
            switch (call.method) {
                case "print":
                    WebView webView = new WebView(getApplicationContext());
                    webView.setWebViewClient(new WebViewClient() {

                        public boolean shouldOverrideUrlLoading(WebView view, String url) {
                            return false;
                        }

                        @Override
                        public void onPageFinished(WebView view, String url) {
                            Log.i(TAG, "page finished loading " + url);
                            createWebPrintJob(view);
                            mWebView = null;
                            result.success(true);
                        }
                    });
                    String html = call.argument("html");
                    webView.loadDataWithBaseURL(null, html, "text/HTML", "UTF-8", null);
                    mWebView = webView;
                    break;
                default:
                    result.notImplemented();
            }
        }
    }

    @TargetApi(Build.VERSION_CODES.KITKAT)
    private void createWebPrintJob(WebView webView) {

        // Get a PrintManager instance
        PrintManager printManager = (PrintManager) MainActivity.this.getSystemService(Context.PRINT_SERVICE);

        // Get a print adapter instance
        PrintDocumentAdapter printAdapter = webView.createPrintDocumentAdapter();

        // Create a print job with name and adapter instance
        String jobName = TAG + " Document";
        PrintJob printJob = printManager.print(jobName, printAdapter,
                new PrintAttributes.Builder().build());
    }
}
