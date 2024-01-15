// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import { Socket } from "phoenix";

// And connect to the path in "lib/discuss_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", { params: { token: window.userToken } });

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/discuss_web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/discuss_web/templates/layout/app.html.heex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/discuss_web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect();

const createSocket = (topicId) => {
  let channel = socket.channel("comments:" + topicId, {});
  channel
    .join()
    .receive("ok", (resp) => {
      const comments = JSON.parse(resp).comments;
      renderComments(comments);
    })
    .receive("error", (resp) => {
      console.log("Unable to join", resp);
    });

  channel.on(`comments:${topicId}:new`, renderComment);

  document.querySelector("#add-comment").addEventListener("click", () => {
    const content = document.querySelector("#comment-content").value;
    channel.push("comment:add", { content: content });
  });
};

function renderComments(comments) {
  const renderedComments = comments.map(({ content, user }) => {
    return commentTemplate(content, user);
  });

  document.querySelector(".collection").innerHTML = renderedComments.join("");
}

function renderComment(event) {
  const renderedComment = commentTemplate(event.comment.content);
  document.querySelector(".collection").innerHTML += renderedComment;
}

function commentTemplate(content, user) {
  let email = "Anonymous";
  if (user) {
    email = user.email;
  }
  return `<li class="p-4 border shadow-sm rounded-lg">
  <div class="text-xs text-gray-500">${email}</div>
  ${content}
  </li>`;
}

window.createSocket = createSocket;
