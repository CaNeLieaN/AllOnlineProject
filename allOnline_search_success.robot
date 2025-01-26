*** Settings ***
Documentation     Test Suite สำหรับทดสอบการสั่งซื้อสินค้าผ่านเว็บ AllOnline
...               โดยเลือกรับสินค้าที่ร้านและชำระเงินด้วย QR Payment
Library    SeleniumLibrary
Test Teardown    Close Browser

*** Variables ***
${TIMEOUT}    20s
${URL}    https://www.allonline.7eleven.co.th/
${PRODUCT_NAME}    COMPRO ตู้เย็นมินิ ความจุ 4 ลิตร รุ่น CP-MINI2 - ขาว
${CUSTOMER_NAME}    นิษฐา สำราญทรัพย์
${PHONE}    0889436594
${STORE_ID}    00262
${STORE_NAME}    สี่แยกบ้านแขก
${STORE_ADDRESS}    เลขที่ ถ.ประชาธิปก, 395-397, แขวงสมเด็จเจ้าพระยา เขตคลองสาน กรุงเทพฯ 10600
${BANK}    ไทยพาณิชย์
${EXPECTED_PRICE}    844.00
${EXPECTED_POINTS}    252

*** Test Cases ***
ลูกค้าสั่งซื้อสินค้าสำเร็จ
    [Documentation]    ทดสอบการสั่งซื้อสินค้าโดยเลือกรับที่ร้านและชำระด้วย QR Payment
    เปิดหน้าเว็บ
    ค้นหาสินค้า
    เลือกสินค้าและยืนยันการซื้อ    
    ไปที่หน้ากรอกข้อมูลการจัดส่ง
    เลือกสาขารับสินค้า
    เลือกวิธีชำระเงิน
    ตรวจสอบรายละเอียดการสั่งซื้อกดชำระเงิน
    # ยืนยันการสั่งซื้อ
    # ตรวจสอบการสั่งซื้อสำเร็จ

*** Keywords ***
เปิดหน้าเว็บ
    Open Browser    url=${URL}    browser=chrome
    Maximize Browser Window
    Wait Until Page Contains Element    name=q    timeout=${TIMEOUT}

ค้นหาสินค้า
    Input Text    name=q    ${PRODUCT_NAME}
    Press Keys    name=q    ENTER
    Wait Until Page Contains Element    css=.product-list    timeout=${TIMEOUT}

เลือกสินค้าและยืนยันการซื้อ
    Wait Until Element Is Visible    xpath=//*[@id="page"]/div[2]/div[2]/div/div/div[2]/div/div/div/div/div/div[3]/div[1]/div/a[1]    timeout=${TIMEOUT}
    Click Element    xpath=//*[@id="page"]/div[2]/div[2]/div/div/div[2]/div/div/div/div/div/div[3]/div[1]/div/a[1]
    Wait Until Element Is Visible    class=btn btn-addtocart btn-green gradient broad add-to-cart add-to-cart-cls-mobile    timeout=${TIMEOUT}
    Click Element    class=btn btn-proceed btn-green gradient broad buy-now

ไปที่หน้ากรอกข้อมูลการจัดส่ง
    Wait Until Element Is Visible    xpath=//*[@id="address-tabs"]/ul/li[1]/a    timeout=${TIMEOUT}
    Click Element    xpath=//*[@id="address-tabs"]/ul/li[1]/a    

เลือกสาขารับสินค้า    
    Input Text    id=second-phone-shipping    ${PHONE}
    Click Element    class=btn store-selector panel-in collapsed
    Input Text    id=user-storenumber-input    ${STORE_ID}
    Click Element    id=btn-check-storenumber
    Wait Until Element Is Visible    class=storefinder-address    timeout=${TIMEOUT}
    Click Element    id=continue-payment-btn

เลือกวิธีชำระเงิน
    Click Element    xpath=//label[contains(text(),'QR Payment')]
    Select From List By Value    id=bankSelection    ${BANK}

ตรวจสอบรายละเอียดการสั่งซื้อกดชำระเงิน
    Wait Until Element Is Visible    class=payment-option-tab COUNTERSERVICE_QR-tab    timeout=${TIMEOUT}
    Click Element    class=btn payment-option-trigger COUNTERSERVICE_QR-tab panel-in active
    Element Should Contain    id=totalAmount    ${EXPECTED_PRICE}
    Element Should Contain    xpath=//*[@id="js-invoice-details-tbody"]/tr[2]/td[2]/b    ฟรี
    Element Should Contain    xpath=//*[@id="js-invoice-details-tbody"]/tr[17]/td[2]    ${EXPECTED_POINTS}
    Click Element    xpath=//*[@id="stepModel"]/div[1]/div[2]/footer/div/div/button
