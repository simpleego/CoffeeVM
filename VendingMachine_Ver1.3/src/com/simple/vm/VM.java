package com.simple.vm;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/vm")
public class VM extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// 제품가격 상수 선언
	private static final int MILK_PRICE = 300;
	private static final int CREAM_PRICE = 300;
	private static final int BLACK_PRICE = 200;

	private static final int COLA_PRICE = 500;
	private static final int FANTA_PRICE = 600;
	private static final int CIDER_PRICE = 700;

	static List<Integer> canCount = new ArrayList<>();

	static {
		canCount.add(10);
		canCount.add(15);
		canCount.add(13);
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html; charset=utf-8");
		PrintWriter writer = response.getWriter();

		System.out.println("canCount" + canCount);
		HttpSession session = request.getSession();

		session.setAttribute("canCount", canCount);
		String canOutArray = "";
		for (Integer i : canCount) {
			canOutArray += i + ",";
		}
		writer.print(canOutArray);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 한글 코드 설정
		request.setCharacterEncoding("utf-8");

		// 메뉴값 읽어오기
		String menu = request.getParameter("menu");
		String canMenu = request.getParameter("canMenu");
		String coin_ = request.getParameter("coin");
		String return_ = request.getParameter("return");

		// 캔을 관리하기 위한 컬렉션을 준비
		List<String> canList = new ArrayList<String>();

		HttpSession session = request.getSession();
		int balence = 0;

		// 세션에 저장된 잔액값을 읽어온다.
		if (session.getAttribute("balence") != null) {
			balence = (int) session.getAttribute("balence");
		}

		// 동전처리 입력처리
		if (coin_ != null) {
			balence = inMoney(coin_, request, balence);
		}

		// 세션에 캔음료 저장된 값을 읽어온다.
		if (session.getAttribute("canList") != null) {
			canList = (List<String>) session.getAttribute("canList");
		}

		// 세션에 캔음료 카운트 값을 읽어온다.
		if (session.getAttribute("canCount") != null) {
			canCount = (List<Integer>) session.getAttribute("canCount");
		}

		// 반환버튼 처리
		if (return_ != null) {
			canList = null;
			String coffee = "";
			session.setAttribute("return_", balence);
			session.setAttribute("coffee", coffee);
			session.setAttribute("canList", canList);
			balence = 0;
		}

		// 메뉴버튼 처리
		if (menu != null) {
			balence = processMenu(menu, request, balence, session);
		}

		// 메뉴버튼 처리
		if (canMenu != null) {
			balence = processCanMenu(canMenu, request, balence, canList, session);
		}

		// 메뉴버튼 활성화/비활성화 처리
		processMenuButton(balence, session);

		// 세션에 잔액을 저장한다.
		session.setAttribute("balence", balence);

		// 자판기 View 호출
		response.sendRedirect("index.jsp");
	}

	private void processMenuButton(int balence, HttpSession session) {

		// 메뉴 버튼 활성화/비활성화
		String btnMilk = "";
		String btnCream = "";
		String btnBlack = "";
		String btnCola = "";
		String btnFanta = "";
		String btnCider = "";

		if (balence >= CIDER_PRICE) {
			btnCider = "enable";
			btnFanta = "enable";
			btnCola = "enable";
			btnMilk = "enable";
			btnCream = "enable";
			btnBlack = "enable";
		} else if (balence >= FANTA_PRICE) {
			btnFanta = "enable";
			btnCola = "enable";
			btnMilk = "enable";
			btnCream = "enable";
			btnBlack = "enable";
		} else if (balence >= COLA_PRICE) {
			btnCola = "enable";
			btnMilk = "enable";
			btnCream = "enable";
			btnBlack = "enable";
		} else if (balence >= MILK_PRICE) {
			btnMilk = "enable";
			btnCream = "enable";
			btnBlack = "enable";
		} else if (balence >= BLACK_PRICE) {
			btnBlack = "enable";
		}

		// Check can Buttons
		if (canCount.get(0) == 0)
			btnCola = "";
		if (canCount.get(1) == 0)
			btnFanta = "";
		if (canCount.get(2) == 0)
			btnCider = "";

		session.setAttribute("btnMilk", btnMilk);
		session.setAttribute("btnCream", btnCream);
		session.setAttribute("btnBlack", btnBlack);
		session.setAttribute("btnCola", btnCola);
		session.setAttribute("btnFanta", btnFanta);
		session.setAttribute("btnCider", btnCider);
	}

	// 커피음료 선택시 처리
	private int processMenu(String menu, HttpServletRequest request, int balence, HttpSession session) {

		// 메뉴처리
		String coffee = null;
		String pname = "";
		int pprice = 0;
		int pcount = 1;

		if (menu != null) {
			// 밀크커피 처리
			// 1. 커피 출력, 금액처리
			switch (menu) {
			case "밀크커피":
				pname="밀크";
				pprice = MILK_PRICE;
				coffee = "milkOut";
				balence -= MILK_PRICE;
				break;
			case "프림커피":
				coffee = "creamOut";
				balence -= CREAM_PRICE;
				pname="프림";
				pprice = CREAM_PRICE;
				break;
			case "블랙커피":
				coffee = "blackOut";
				balence -= BLACK_PRICE;
				pname="블랙";
				pprice = BLACK_PRICE;
				break;
			default:
				break;
			}
		}

		// 상품 판매정보를 DB에 저장
		try {
			saleDB(pname, pprice, pcount);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}

		session.setAttribute("coffee", coffee);
		return balence;
	}

	// 캔음료 선택시 처리
	private int processCanMenu(String menu, HttpServletRequest request, int balence, List<String> canList,
			HttpSession session) {

		// 메뉴처리
		String can = null;
		String pname = "";
		int pprice = 0;
		int pcount = 1;

		if (menu != null) {
			switch (menu) {
			case "콜라":
				pname = "콜라";
				can = "canColaOut";
				balence -= COLA_PRICE;
				pprice = COLA_PRICE;
				canCount.set(0, canCount.get(0) - 1);
				break;
			case "환타":
				pname = "환타";
				can = "canFantaOut";
				balence -= FANTA_PRICE;
				pprice = FANTA_PRICE;
				canCount.set(1, canCount.get(1) - 1);
				break;
			case "사이다":
				pname = "사이다";
				can = "canCiderOut";
				balence -= CIDER_PRICE;
				pprice = CIDER_PRICE;
				canCount.set(2, canCount.get(2) - 1);
				break;
			default:
				break;
			}
		}

		// 상품 판매정보를 DB에 저장
		try {
			saleDB(pname, pprice, pcount);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}

		if (can != null)
			canList.add(can);

		session.setAttribute("canList", canList);
		session.setAttribute("canCount", canCount);
		return balence;
	}

	private int inMoney(String coin_, HttpServletRequest request, int balence) {

		// 금액처리
		int coin = 0;

		if (coin_ != null && !coin_.equals("")) {
			coin = Integer.parseInt(coin_);
			balence += coin;
		}
		return balence;
	}

	private void saleDB(String pname, int pprice, int pcount) throws ClassNotFoundException {

		Connection conn = null;
		PreparedStatement pstmt = null;

		String url = "jdbc:mysql://localhost:3309/VM";
		String id = "root";
		String password = "pjc0129";
		String sql = "INSERT INTO sales(pname,pprice,pcount) VALUES(?, ?, ?)";

		try {

			Class.forName("org.mariadb.jdbc.Driver");
			conn = DriverManager.getConnection(url, id, password);
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pname);
			pstmt.setInt(2, pprice);
			pstmt.setInt(3, pcount);
			pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		}

		try {
			pstmt.close();
			conn.close();

		} catch (SQLException e) {
			e.printStackTrace();
		}

		System.out.println("연결성공");
	}
}