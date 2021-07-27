package web;

import org.junit.jupiter.api.Test;

import web.filerec.file_rec;

public class FileDbTests {

	@Test
	final void testFileRecSave() throws ClassNotFoundException {
		Class.forName("org.hibernate.jpa.HibernatePersistenceProvider");
		file_rec rec = new file_rec();
		rec.setId(Integer.MAX_VALUE - 5); //causes detached entity error
		rec.setPath("c:\\temp");
		rec.setbKey(String.valueOf(Integer.MAX_VALUE - 7));
		web.DBUtil.newRow(rec, "sales");

	}


}
