import { HelloWorld } from "@monorepo/foo-lib";
import React from "react";
import ReactDOM from "react-dom/client";

const el = document.createElement("div");
document.body.appendChild(el);
const root = ReactDOM.createRoot(el);
root.render(<HelloWorld />);