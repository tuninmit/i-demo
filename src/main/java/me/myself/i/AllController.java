package me.myself.i;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


@RestController
public class AllController {

    @Autowired
    private HttpServletRequest request;

    @GetMapping(value = "/get")
    public Object get() {
        System.out.println("Receive request GET /get " + request.getQueryString());
        return request.getParameterMap();
    }

    @PostMapping(value = "/post")
    public Object post(@RequestBody Object body) {
        System.out.println("Receive request POST /post");
        return body;
    }
}
