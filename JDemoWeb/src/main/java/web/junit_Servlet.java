package web;

import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintStream;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.GetMapping;

import junit.framework.TestSuite;
import junit.textui.ResultPrinter;
import junit.textui.TestRunner;

/**
 * Servlet implementation class junit_Servlet
 * 
 * Similar goal as https://www.oracle.com/technical-resources/articles/server-side-unit-tests.html
 */
@WebServlet("/junit")
public class junit_Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public junit_Servlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
//    @GetMapping("/junit")
    protected void doGet(HttpServletRequest request, HttpServletResponse res) throws ServletException, IOException {
		
		OutputStream outputStream = res.getOutputStream();
		PrintWriter w = new PrintWriter(new OutputStreamWriter(outputStream));
		w.println("<html><head/><body><pre>");
		
		Main_sbw_SpringBootApplicationEmbeddedWebServer.runJUnits(new PrintStream(outputStream));

		w.println("</pre></html>");

	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
