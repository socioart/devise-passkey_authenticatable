import Pagehook from "pagehook";
// 1Password 導入時に JSON.stringify でエラー出たので polyfill 利用する
import {
  get,
  parseRequestOptionsFromJSON,
} from "@github/webauthn-json/browser-ponyfill";

function createElement(parent: HTMLElement, tagName: string, attributes: Record<string, string> = {}): HTMLElement {
  const element = document.createElement(tagName);
  Object.entries(attributes).forEach(([key, value]) => {
    element.setAttribute(key, value);
  });
  parent.appendChild(element);
  return element;
}

// utils
function createFormElement(action: string): HTMLFormElement {
  const form = createElement(document.body, "form", {
    method: "post",
    action,
    enctype: "multipart/form-data",
    "accept-charset": "UTF-8",
  }) as HTMLFormElement;
  createElement(form, "input", {
    type: "hidden",
    name: "utf8",
    value: "✓",
  });
  createElement(form, "input", {
    type: "hidden",
    name: "authenticity_token",
    value: (document.querySelector("meta[name='csrf-token']") as HTMLMetaElement).content,
  });
  return form as HTMLFormElement;
}


// Authentication
// = pagehook "devise/sessions/new", {options: @public_key_credential_request_options.as_json}
Pagehook.register("devise/sessions/new", (data) => {
  function submitCredential(credential: any) {
    // form を作成して送信
    const form = createFormElement("/users/sign_in");
    createElement(form, "input", {
      type: "hidden",
      name: "credential_json",
      value: JSON.stringify(credential)
    });
    form.submit();
  }

  async function initializePasskeyUI() {
    if (window.PublicKeyCredential === undefined) return;
    if (window.PublicKeyCredential.isConditionalMediationAvailable === undefined) return;
    if (data.options === null) {
      console.warn("No options provided for passkey authentication.");
      return;
    }

    const publicKeyCredentialRequestOptions = parseRequestOptionsFromJSON(
      {publicKey: data.options},
    );

    // フォームオートフィルログインが可能か確認
    // const conditionMediationAvailable = await window.PublicKeyCredential.isConditionalMediationAvailable();
    const conditionMediationAvailable = false;
    if (conditionMediationAvailable) {
      const credential = await get(
        Object.assign(
          {
            mediation: "conditional",
          },
          publicKeyCredentialRequestOptions
        )
      );
      submitCredential(credential);
    } else {
      // 「パスキーでサインイン」ボタン表示
      const signInWithPasskeyContainer = document.querySelector("#sign-in-with-passkey") as HTMLElement;
      signInWithPasskeyContainer.classList.remove("d-none");
      signInWithPasskeyContainer.querySelector("button")!.addEventListener("click", async () => {
        const credential = await get(publicKeyCredentialRequestOptions);
        submitCredential(credential);
      });
    }
  }

  initializePasskeyUI();
});

// Creation
// = pagehook "devise/passkeys/index", {options: @public_key_credential_creation_options.as_json}
Pagehook.register("devise/passkeys/index", (data) => {
  async function registerPasskey() {
    if (window.PublicKeyCredential === undefined) return;
    if (window.PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable === undefined) return;

    // パスキーの登録が可能か確認
    const available = await window.PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable();
    if (available === false) return;

    const publicKeyCredentialCreationOptions = parseCreationOptionsFromJSON(
      {publicKey: data.options},
    );
    const credential = await create(publicKeyCredentialCreationOptions)

    // form を作成して送信
    const form = createFormElement("/users/passkeys");
    createElement(form, "input", {
      type: "hidden",
      name: "credential_json",
      value: JSON.stringify(credential)
    });

    form.submit();
  }

  document.querySelector("#register-passkey")?.addEventListener("click", function() {
    registerPasskey();
  });
})

// Signals
// = pagehook "passkey_signals", {rpId: WebAuthn.configuration.rp_id, userId: current_user.passkey_user_id, allAcceptedCredentialIds: current_user.passkeys.pluck(:credential_id)}
Pagehook.register("passkey_signals", (data) => {
  async function asyncHandler(data) {
    // 利用可能な証明書一覧から、利用不能なパスキーの削除をうながす
    // 削除が起こりがちなパスキー管理画面で実行
    if (data.allAcceptedCredentialIds && data.allAcceptedCredentialIds.length > 0 && window.PublicKeyCredential && window.PublicKeyCredential.signalAllAcceptedCredentials) {
      await PublicKeyCredential.signalAllAcceptedCredentials(
        {
          rpId: data.rpId,
          userId: data.userId,
          allAcceptedCredentialIds: data.allAcceptedCredentialIds,
        },
      );
    }

    // name, displayName の更新をうながす
    if (data.name && data.displayName && window.PublicKeyCredential && window.PublicKeyCredential.signalCurrentUserDetails) {
      await PublicKeyCredential.signalCurrentUserDetails({
        rpId: data.rpId,
        userId: data.userId,
        name: data.name,
        displayName: data.displayName,
      });
    }
  }

  asyncHandler(data);
});


