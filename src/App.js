import React from "react";
import { Link, Routes, Route, Outlet } from "react-router-dom";
import { env } from "./env";
const Links = () => {
  return (
    <ul
      style={{
        display: "flex",
        flexDirection: "row",
        gap: 20,
        listStyle: "none",
        backgroundColor: "#ddd",
        padding: 12,
      }}
    >
      <li>
        <Link to="/">home</Link>
      </li>
      <li>
        <Link to="route1">Route 1</Link>
      </li>
      <li>
        <Link to="route2">Route 2</Link>
      </li>
      <li>
        <Link to="route3">Route 3</Link>
      </li>
      <li>
        <Link to="route4">Route 4</Link>
      </li>
      <li>
        <Link to="route5">Route 5</Link>
      </li>
    </ul>
  );
};
console.log(env);
const App = () => {
  return (
    <Routes>
      <Route
        path="/"
        element={
          <div>
            <Links />
            <Outlet />
          </div>
        }
      >
        <Route index element={<div>Hello</div>} />
        <Route path="route1" element={<div>Route 1</div>} />
        <Route path="route2" element={<div>Route 2</div>} />
        <Route path="route3" element={<div>Route 3</div>} />
        <Route path="route4" element={<div>Route 4</div>} />
        <Route path="route5" element={<div>Route 5</div>} />
      </Route>
    </Routes>
  );
};

export default App;
