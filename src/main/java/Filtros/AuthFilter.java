package Filtros;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicialización del filtro
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI();

        // 1. Permitir el acceso a recursos estáticos y rutas públicas
        if (path.endsWith(".css") || path.endsWith(".js") || 
            path.endsWith(".svg") || path.endsWith(".png") || path.endsWith(".jpg") ||
            path.endsWith("login.jsp") || path.endsWith("loginSv") ||
            path.contains("/CSS/") || path.contains("/JS/") || path.contains("/images/")) {
            
            chain.doFilter(request, response);
            return;
        }

        // 2. Validación de Sesión para todo lo demás
        HttpSession session = req.getSession(false);

        // Si no hay sesión o no existe el atributo usuarioLogeado, redirigir al login
        if (session == null || session.getAttribute("usuarioLogeado") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
        } else {
            // Usuario autenticado, permitir que la petición continúe hacia el Servlet o JSP destino
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        // Destrucción del filtro
    }
}
